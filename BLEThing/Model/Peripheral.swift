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
}
