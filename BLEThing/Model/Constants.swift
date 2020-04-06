//
//  Constants.swift
//  BLEThing
//
//  Created by Nisum on 30-03-20.
//

import Foundation

struct Constants {

    // BLE
    static let uptimeServiceUUID = "ff51b30e-d7e2-4d93-8842-a7c4a57dfb07"

    enum Characteristics: String, CaseIterable {
        case uptimeCharacteristicUUID = "ff51b30e-d7e2-4d93-8842-a7c4a57dfb09"

        var displayName: String {
            switch self {
            case .uptimeCharacteristicUUID:
                return "Uptime"
            }
        }
    }
}
