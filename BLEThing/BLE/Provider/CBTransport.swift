//
//  CBTransport.swift
//  BLEThing
//
//  Created by Nisum on 05-03-20.
//

import Foundation
import CoreBluetooth
import Combine

class CBTransport: NSObject, Transport {

    static let shared = CBTransport()

    var centralManager: CBCentralManager!

    // MARK: - Private properties
    private var _discoveredPeripheralsSubject = PassthroughSubject<Connectable, Never>()
    private var _connectedPeripheralSubject = PassthroughSubject<ConnectableState, Never>()
    private var _connectedPeripheral: CBPeripheral?
    private var _discoveredPeripherals = Set<CBPeripheral>()
    private var _discoveredCharacteristicsSubject = PassthroughSubject<ConnectableCharacteristic, Never>()
    private var _discoveredCharacteristics = Set<CBCharacteristic>()

    // MARK: - Transport conformance
    var connectedPeripheral: Connectable?
    var discoveredPeripheralsPublisher: AnyPublisher<Connectable, Never>!
    var connectedPeripheralPublisher: AnyPublisher<ConnectableState, Never>!
    var discoveredCharacteristicsPublisher: AnyPublisher<ConnectableCharacteristic, Never>!
    
    // MARK: - Services

    // Creates a Core Bluetooth UUID object from a 16-, 32-, or 128-bit UUID string.
    let uptimeServiceCBUUID = CBUUID(string: Constants.uptimeServiceUUID)

    // MARK: - Characteristics

    // See CBCharacteristicProperties struct documentation.
    let uptimeCharacteristicCBUUID = Constants.Characteristics.uptimeCharacteristicUUID.rawValue

    // MARK: - Init
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)

        // TODO: test this
        cleanDiscoveredServices()

        discoveredPeripheralsPublisher = _discoveredPeripheralsSubject.eraseToAnyPublisher()
        connectedPeripheralPublisher = _connectedPeripheralSubject.eraseToAnyPublisher()
        discoveredCharacteristicsPublisher = _discoveredCharacteristicsSubject.eraseToAnyPublisher()
    }

    // MARK: - Methods

    func scanForKnownPeripherals() {
        centralManager.scanForPeripherals(withServices: [uptimeServiceCBUUID])
    }

    func connect(toPeripheral peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        _connectedPeripheral = peripheral
        _connectedPeripheral?.delegate = self // see CBPeripheralDelegate implementation.
        centralManager.stopScan()
        centralManager.connect(peripheral)
    }

    func connect(toConnectable connectable: Connectable) {
        let pers = _discoveredPeripherals.filter({ (peripheral) -> Bool in
            connectable.uuid == peripheral.uuid
        })

        guard let first = pers.first else {
            // Send error through _connectedPeripheralSubject
            _connectedPeripheralSubject.send(.disconnected)
            return
        }

        connect(toPeripheral: first)
    }

    func writeTime(_ seconds: UInt) {
        let chars = _discoveredCharacteristics.filter({ (characteristic) -> Bool in
            characteristic.properties.contains(.write)
        })

        guard let first = chars.first else {
            // Send error through _connectedPeripheralSubject
            _connectedPeripheralSubject.send(.disconnected)
            return
        }

        var data: Data!

        do {
            data = try JSONEncoder().encode(seconds)
        }
        catch {
            print("Couldn't create the json string for date \(self)")
            return
        }

        _connectedPeripheral?.writeValue(data, for: first, type: .withResponse)
    }

    func cancelConnection() {
        if let peripheral = _connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
}

// MARK: - CBCentralManagerDelegate

extension CBTransport: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            print("central.state is .unknown")
        case .resetting:
            print("central.state is .resetting")
        case .unsupported:
            print("central.state is .unsupported")
        case .unauthorized:
            print("central.state is .unauthorized")
        case .poweredOff:
            print("central.state is .poweredOff")
        case .poweredOn:
            scanForKnownPeripherals()
            print("central.state is .poweredOn")
        @unknown default:
            print("central.state is .unknown")
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        _discoveredPeripheralsSubject.send(peripheral.toConnectable())
        _discoveredPeripherals.insert(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        _connectedPeripheralSubject.send(.connected)

        // TODO: test this
        cleanDiscoveredServices()

        // discoverServices(_ serviceUUIDs: [CBUUID]?) requires didDiscoverServices implementation from CBPeripheralDelegate
        _connectedPeripheral?.discoverServices([uptimeServiceCBUUID])
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        _connectedPeripheralSubject.send(.disconnected)
    }

    func cleanDiscoveredServices() {
        _discoveredPeripheralsSubject = PassthroughSubject<Connectable, Never>()
        _connectedPeripheralSubject = PassthroughSubject<ConnectableState, Never>()
        _discoveredCharacteristicsSubject = PassthroughSubject<ConnectableCharacteristic, Never>()
        _discoveredCharacteristics = Set<CBCharacteristic>()
        discoveredPeripheralsPublisher = _discoveredPeripheralsSubject.eraseToAnyPublisher()
        connectedPeripheralPublisher = _connectedPeripheralSubject.eraseToAnyPublisher()
        discoveredCharacteristicsPublisher = _discoveredCharacteristicsSubject.eraseToAnyPublisher()
    }

}

// MARK: - CBPeripheralDelegate

extension CBTransport: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            // To obtain the characteristics of a service, you’ll need to explicitly request the discovery of the service’s characteristics.
            peripheral.discoverCharacteristics(nil, for: service) // requires didDiscoverCharacteristicsFor implementation
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            print("Characteristic \(characteristic.uuid)")
            if characteristic.properties.contains(.read) {
                print("Characteristic properties contains .read")
            }
            if characteristic.properties.contains(.notify) {
                print("Characteristic properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            }
            if characteristic.properties.contains(.write) {
                print("Characteristic properties contains .write")
            }

            _discoveredCharacteristicsSubject.send(characteristic.toConnectable())
            _discoveredCharacteristics.insert(characteristic)
            peripheral.readValue(for: characteristic) // requires peripheral(_:didUpdateValueFor:error:) implementation.
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid.uuidString.uppercased() {
        case uptimeCharacteristicCBUUID.uppercased():
            if let value = characteristic.value, let string = valueToString(from: value) {
//                print("uptimeCharacteristic value: \(uptime(from: characteristic))")
                print("uptimeCharacteristic value: \(string)")
            } else {
                print(characteristic.value ?? "no value")
            }
        default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }

}

// MARK: - Utils

extension CBTransport {

    private func valueToString(from value: Data) -> String? {
        guard let string = String(bytes: value, encoding: .utf8) else {
            print("CBServiceProvider: not a valid UTF-8 sequence")
            return nil
        }

        return string
    }

//    private func uptime(from characteristic: CBCharacteristic) -> Int {
//        guard let characteristicData = characteristic.value else {
//            return 0
//        }
//
//        guard let string = String(bytes: characteristicData, encoding: .utf8) else {
//            print("CBServiceProvider: not a valid UTF-8 sequence")
//            return 0
//        }
//
//        guard let dic = JSONStringToDictionary(string: string) else {
//            return 0
//        }
//
//        return dic["uptime"] as? Int ?? 0
//    }

//    func JSONStringToDictionary(string: String) -> [String: Any]? {
//        if let data = string.data(using: .utf8) {
//            do {
//                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
//        return nil
//    }

}

// MARK: - CBPeripheral Connectable conformance

extension CBPeripheral: Connectable {
    var serviceIds: [String] {
        [Constants.uptimeServiceUUID]
    }

    var uuid: String {
        self.identifier.uuidString
    }

    func toConnectable() -> some Connectable {
        return self
    }
}

// MARK: - CBService ConnectableService conformance

extension CBCharacteristic: ConnectableCharacteristic {
    var types: [ConnectableCharacteristicType] {
        var pptList = [ConnectableCharacteristicType]()
        if self.properties.contains(.write) {
            pptList.append(.write)
        }
        if self.properties.contains(.read) {
            pptList.append(.read)
        }
        if self.properties.contains(.notify) {
            pptList.append(.notify)
        }
        return pptList
    }

    var uuidString: String {
        self.uuid.uuidString
    }

    func toConnectable() -> some ConnectableCharacteristic {
        return self
    }
}
