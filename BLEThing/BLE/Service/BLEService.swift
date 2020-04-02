//
//  BLEService.swift
//  BLEThing
//
//  Created by Nisum on 05-03-20.
//

import Foundation
import Combine

enum BLEError: Error {
    case error
}

protocol BLEService {
    associatedtype P: Peripheral
    var connectedPeripheral: P? { get }
    var discoveredPeripheralPublisher: AnyPublisher<P, Never>! { get }

//    func connect(toPeripheral peripheral: Peripheral)
//    func readUptime() -> UInt
//    func writeTime(time: UInt)
//    func readState() -> PeripheralState
}
