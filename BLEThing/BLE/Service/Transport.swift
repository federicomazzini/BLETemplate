//
//  Transport.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import Foundation
import Combine

protocol Transport {
    var connectedPeripheral: Connectable? { get }
    var discoveredPeripheralsPublisher: AnyPublisher<Connectable, Never>! { get }
    var connectedPeripheralPublisher: AnyPublisher<ConnectableState, Never>! { get }
    var discoveredCharacteristicsPublisher: AnyPublisher<ConnectableCharacteristic, Never>! { get }

    func connect(toConnectable connectable: Connectable)
    func writeTime(_ seconds: UInt)
    func cancelConnection()
}
