//
//  Transport.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import Foundation
import Combine

//enum TransportError: Error {
//    case didDisconnect
//}

protocol Transport {
    var connectedPeripheral: Connectable? { get }
    var discoveredPeripheralsPublisher: AnyPublisher<Connectable, Never>! { get }
    var connectedPeripheralPublisher: AnyPublisher<Void, Never>! { get }
    var discoveredCharacteristicsPublisher: AnyPublisher<ConnectableCharacteristic, Never>! { get }

    func connect(toConnectable connectable: Connectable)

//    func readUptime() -> UInt
//    func writeTime(time: UInt)
//    func readState() -> PeripheralState
}
