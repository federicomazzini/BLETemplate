//
//  Peripheral.swift
//  BLEThing
//
//  Created by Nisum on 30-03-20.
//

import Foundation

enum PeripheralState {
    case idle, timerSet
}

protocol Peripheral {
    var serviceIds: [String] { get }
    var uuid: String { get }
}

struct MockPeripheral: Peripheral {
    var serviceIds: [String] = ["serviceId:123:123:123"]
    var uuid: String = "uuid:123:123:123"
}
