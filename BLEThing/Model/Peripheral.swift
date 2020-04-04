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

    static let mockPeripheral = Peripheral(serviceIds: ["serviceId:123:123:123"], uuid: "uuid:123:123:123")
}
