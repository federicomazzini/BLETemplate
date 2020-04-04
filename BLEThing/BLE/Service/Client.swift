//
//  Client.swift
//  BLEThing
//
//  Created by Nisum on 05-03-20.
//

import Foundation
import Combine

enum BLEError: Error {
    case error
}

struct Client {
    let transport: Transport

    init(transport: Transport = CBTransport.shared) {
        self.transport = transport
    }

    var connectedPeripheral: Connectable?
    var discoveredPeripheralPublisher: AnyPublisher<Connectable, Never>!

//    func connect(toPeripheral peripheral: Peripheral)
//    func readUptime() -> UInt
//    func writeTime(time: UInt)
//    func readState() -> PeripheralState
}
