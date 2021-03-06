//
//  Connectable.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import Foundation

enum ConnectableCharacteristicType {
    case read, write, notify
}

enum ConnectableState {
    case connected, disconnected
}

protocol Connectable {
    var serviceIds: [String] { get }
    var uuid: String { get }
}

protocol ConnectableCharacteristic {
    var uuidString: String { get }
    var types: [ConnectableCharacteristicType] { get }
    var characteristicValue: Data? { get }
}
