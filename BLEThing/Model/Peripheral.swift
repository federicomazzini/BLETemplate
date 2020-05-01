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
    var types: [ConnectableCharacteristicType]

    init(uuid: String, types: [ConnectableCharacteristicType]) {
        self.uuidString = uuid
        self.types = types
    }

    init(connectableCharacteristic: ConnectableCharacteristic) {
        self.uuidString = connectableCharacteristic.uuidString
        self.types = connectableCharacteristic.types
    }

    static let mockCharacteristic = Characteristic(
        uuid: Constants.Characteristics.uptimeCharacteristicUUID.rawValue,
        types: [.read]
    )
}
