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
    var discoveredPeripheralPublisher: AnyPublisher<Connectable, Never>! { get }
}
