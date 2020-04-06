//
//  Peripheral.swift
//  BLEThing
//
//  Created by Nisum on 30-03-20.
//

import Foundation

struct Peripheral: Connectable {
    var serviceIds: [String]
    var uuid: String

    init(serviceIds: [String], uuid: String) {
        self.serviceIds = serviceIds
        self.uuid = uuid
    }

    init(connectable: Connectable) {
        self.serviceIds = connectable.serviceIds
        self.uuid = connectable.uuid
    }

    static let mockPeripheral = Peripheral(
        serviceIds: [Constants.Characteristics.uptimeCharacteristicUUID.rawValue],
        uuid: Constants.uptimeServiceUUID
    )
}

struct Characteristic: ConnectableCharacteristic {
    var uuidString: String
    var type: ConnectableCharacteristicType

    init(uuid: String, type: ConnectableCharacteristicType) {
        self.uuidString = uuid
        self.type = type
    }

    init(connectableCharacteristic: ConnectableCharacteristic) {
        self.uuidString = connectableCharacteristic.uuidString
        self.type = connectableCharacteristic.type
    }

    static let mockCharacteristic = Characteristic(
        uuid: Constants.Characteristics.uptimeCharacteristicUUID.rawValue,
        type: .read
    )
}
