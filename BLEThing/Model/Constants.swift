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
        case deviceStateCharacteristicUUID = "ff51b30e-d7e2-4d93-8842-a7c4a57dfb09"
        case writeCharacteristicUUID = "0a60d08c-80c9-4332-899b-27d54b14f0d2"

        var displayName: String {
            switch self {
            case .deviceStateCharacteristicUUID:
                return "Device State"
            case .writeCharacteristicUUID:
                return "Set Time"
            }
        }
    }
}
