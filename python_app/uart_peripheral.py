# import sys
import dbus, dbus.mainloop.glib
from gi.repository import GLib
from example_advertisement import Advertisement
from example_advertisement import register_ad_cb, register_ad_error_cb
from example_gatt_server import Service, Characteristic
from example_gatt_server import register_app_cb, register_app_error_cb
# from threading import Thread
import concurrent.futures
from threading import Timer

from audio_player import play_session
 
BLUEZ_SERVICE_NAME =           'org.bluez'
DBUS_OM_IFACE =                'org.freedesktop.DBus.ObjectManager'
LE_ADVERTISING_MANAGER_IFACE = 'org.bluez.LEAdvertisingManager1'
GATT_MANAGER_IFACE =           'org.bluez.GattManager1'
GATT_CHRC_IFACE =              'org.bluez.GattCharacteristic1'
UART_SERVICE_UUID =            'ff51b30e-d7e2-4d93-8842-a7c4a57dfb07'
UART_RX_CHARACTERISTIC_UUID =  '0a60d08c-80c9-4332-899b-27d54b14f0d2'
UART_TX_CHARACTERISTIC_UUID =  'ff51b30e-d7e2-4d93-8842-a7c4a57dfb09'
LOCAL_NAME =                   'rpi-gatt-server'
mainloop = None

audioScheduled = False # Prevent the scheduling of sessions in parallel.

notifyInterval = 3000 # in ms

def end_schedule():
    global audioScheduled
    audioScheduled = False
    print("Ended session blocking timer")

def start_schedule():
    global audioScheduled
    audioScheduled = True
    print("Starting session blocking timer")
 
class TxCharacteristic(Characteristic):
    def __init__(self, bus, index, service):
        Characteristic.__init__(self, bus, index, UART_TX_CHARACTERISTIC_UUID, ['notify'], service)
        self.notifying = False
        #GLib.io_add_watch(sys.stdin, GLib.IO_IN, self.on_console_input)
 
    def update_schedule_state(self):
        value = []
        global audioScheduled
        s = str(audioScheduled)
        print('Notify Timer characteristic, schedule state: ' + s)

        for c in s:
            value.append(dbus.Byte(c.encode()))
        self.PropertiesChanged(GATT_CHRC_IFACE, {'Value': value}, [])

        return self.notifying

    def _update_schedule_state(self):
        global notifyInterval
        print('Notify Timer characteristic: Setting up timeout')

        if not self.notifying:
            print('Notify Timer characteristic canceled!!!')
            return

        GLib.timeout_add(notifyInterval, self.update_schedule_state)
 
    # def send_tx(self, s):
    #     if not self.notifying:
    #         return
    #     value = []
    #     for c in s:
    #         value.append(dbus.Byte(c.encode()))
    #     self.PropertiesChanged(GATT_CHRC_IFACE, {'Value': value}, [])
 
    def StartNotify(self):
        if self.notifying:
            print('Already notifying, nothing to do')
            return
        self.notifying = True
        self._update_schedule_state()
 
    def StopNotify(self):
        if not self.notifying:
            print('Not notifying, nothing to do')
            return
        self.notifying = False
        self._update_schedule_state()
 
class RxCharacteristic(Characteristic):
    def __init__(self, bus, index, service):
        Characteristic.__init__(self, bus, index, UART_RX_CHARACTERISTIC_UUID,
                                ['write'], service)
 
    def WriteValue(self, value, options):
        global audioScheduled
        if audioScheduled:
            print("Session blocked: session blocking timer not finished")
            return

        start_schedule()

        print('remote: {}'.format(bytearray(value).decode()))
        minutes = int(bytearray(value).decode())
        # thread = Thread(target = play_session, args = (minutes, ))
        # thread.start()

        with concurrent.futures.ThreadPoolExecutor() as executor:
            future = executor.submit(play_session, minutes)
            sessionDuration = future.result()
            print("Received session duration: " + str(int(sessionDuration)))
            print("Starting session blocking timer")
            timer = Timer(sessionDuration, end_schedule)
            timer.start()
 
class UartService(Service):
    def __init__(self, bus, index):
        Service.__init__(self, bus, index, UART_SERVICE_UUID, True)
        self.add_characteristic(TxCharacteristic(bus, 0, self))
        self.add_characteristic(RxCharacteristic(bus, 1, self))
 
class Application(dbus.service.Object):
    def __init__(self, bus):
        self.path = '/'
        self.services = []
        dbus.service.Object.__init__(self, bus, self.path)
 
    def get_path(self):
        return dbus.ObjectPath(self.path)
 
    def add_service(self, service):
        self.services.append(service)
 
    @dbus.service.method(DBUS_OM_IFACE, out_signature='a{oa{sa{sv}}}')
    def GetManagedObjects(self):
        response = {}
        for service in self.services:
            response[service.get_path()] = service.get_properties()
            chrcs = service.get_characteristics()
            for chrc in chrcs:
                response[chrc.get_path()] = chrc.get_properties()
        return response
 
class UartApplication(Application):
    def __init__(self, bus):
        Application.__init__(self, bus)
        self.add_service(UartService(bus, 0))
 
class UartAdvertisement(Advertisement):
    def __init__(self, bus, index):
        Advertisement.__init__(self, bus, index, 'peripheral')
        self.add_service_uuid(UART_SERVICE_UUID)
        self.add_local_name(LOCAL_NAME)
        self.include_tx_power = True
 
def find_adapter(bus):
    remote_om = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, '/'),
                               DBUS_OM_IFACE)
    objects = remote_om.GetManagedObjects()
    for o, props in objects.items():
        if LE_ADVERTISING_MANAGER_IFACE in props and GATT_MANAGER_IFACE in props:
            return o
        print('Skip adapter:', o)
    return None
 
def main():
    global mainloop
    dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)
    bus = dbus.SystemBus()
    adapter = find_adapter(bus)
    if not adapter:
        print('BLE adapter not found')
        return
 
    service_manager = dbus.Interface(
                                bus.get_object(BLUEZ_SERVICE_NAME, adapter),
                                GATT_MANAGER_IFACE)
    ad_manager = dbus.Interface(bus.get_object(BLUEZ_SERVICE_NAME, adapter),
                                LE_ADVERTISING_MANAGER_IFACE)
 
    app = UartApplication(bus)
    adv = UartAdvertisement(bus, 0)
 
    mainloop = GLib.MainLoop()
 
    service_manager.RegisterApplication(app.get_path(), {},
                                        reply_handler=register_app_cb,
                                        error_handler=register_app_error_cb)
    ad_manager.RegisterAdvertisement(adv.get_path(), {},
                                     reply_handler=register_ad_cb,
                                     error_handler=register_ad_error_cb)
    try:
        mainloop.run()
    except KeyboardInterrupt:
        print('\nReleasing Advertisement')
        adv.Release()
 
if __name__ == '__main__':
    main()

