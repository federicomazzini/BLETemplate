//
//  CBServiceProvider.swift
//  BLEThing
//
//  Created by Nisum on 05-03-20.
//

import Foundation
import CoreBluetooth
import Combine

class CBServiceProvider: NSObject, BLEService {

    var centralManager: CBCentralManager!

    // MARK: - Peripherals

    var connectedPeripheral: CBPeripheral?
    private var discoveredPeripheralSubject = PassthroughSubject<CBPeripheral, Never>()
    var discoveredPeripheralPublisher: AnyPublisher<CBPeripheral, Never>!
    
    // MARK: - Services

    // Creates a Core Bluetooth UUID object from a 16-, 32-, or 128-bit UUID string.
    let uptimeServiceCBUUID = CBUUID(string: Constants.uptimeServiceUUID)

    // MARK: - Characteristics

    // See CBCharacteristicProperties struct documentation.
    let uptimeCharacteristicCBUUID = CBUUID(string: Constants.uptimeCharacteristicUUID)
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        discoveredPeripheralPublisher = discoveredPeripheralSubject.eraseToAnyPublisher()
    }

    func scan(ids: [String], options: [String: Any]?) {
        let cbuuids = ids.map { CBUUID(string: $0) }
        centralManager.scanForPeripherals(withServices: cbuuids, options: options)
    }

    func scanForKnownPeripherals() {
        centralManager.scanForPeripherals(withServices: [uptimeServiceCBUUID])
    }
}

extension CBServiceProvider: CBCentralManagerDelegate {

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
        discoveredPeripheralSubject.send(peripheral)

//        connectedPeripheral = peripheral
//        connectedPeripheral.delegate = self // see CBPeripheralDelegate implementation.
//        centralManager.stopScan()
//        centralManager.connect(connectedPeripheral)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        connectedPeripheral?.discoverServices([uptimeServiceCBUUID]) // requires didDiscoverServices implementation from CBPeripheralDelegate
    }

    func connect(toPeripheral peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self // see CBPeripheralDelegate implementation.
        centralManager.stopScan()
        centralManager.connect(peripheral)
    }
}

extension CBServiceProvider: CBPeripheralDelegate {

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
            }

            peripheral.readValue(for: characteristic) // requires peripheral(_:didUpdateValueFor:error:) implementation.
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
          case uptimeCharacteristicCBUUID:
            print(characteristic.value ?? "no value")
            print("uptimeCharacteristic value: \(uptime(from: characteristic))")
          default:
            print("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
}

extension CBServiceProvider {
    private func uptime(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else {
            return 0
        }

        guard let string = String(bytes: characteristicData, encoding: .utf8) else {
            print("CBServiceProvider: not a valid UTF-8 sequence")
            return 0
        }

        guard let dic = convertToDictionary(text: string) else {
            return 0
        }

        return dic["uptime"] as? Int ?? 0
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

// MARK: - Peripheral

extension CBPeripheral: Peripheral {
    var serviceIds: [String] {
        [Constants.uptimeServiceUUID]
    }

    var uuid: String {
        self.identifier.uuidString
    }
}
