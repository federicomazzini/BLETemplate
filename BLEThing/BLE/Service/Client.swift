//
//  Client.swift
//  BLEThing
//
//  Created by Nisum on 05-03-20.
//

import Foundation
import Combine

final class Client {
    let transport: Transport

    init(transport: Transport = CBTransport.shared) {
        self.transport = transport
    }
}
