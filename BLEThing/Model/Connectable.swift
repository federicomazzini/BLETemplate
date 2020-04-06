//
//  Connectable.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import Foundation

enum ConnectableState {
    case idle, timerSet
}

protocol Connectable {
    var serviceIds: [String] { get }
    var uuid: String { get }
}

protocol ConnectableService {
    var uuidString: String { get }
}
