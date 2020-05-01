//
//  CharacteristicsViewModel.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import Foundation
import Combine

class CharacteristicsViewModel: ObservableObject, Identifiable {

    @Published var dataSource: [CharacteristicRowViewModel] = []
    @Published var deviceStateDataSource: DeviceStateRowViewModel?
    @Published var selectWriteCharacteristic: Bool = false

    private var disposables = Set<AnyCancellable>()

    var client: Client!

    init(client: Client = Client()) {
        self.client = client
        
        // get discovered characteristics and update dataSource
        _ = client.transport.discoveredCharacteristicsPublisher
            .sink { (connectableCharacteristic) in

                // create Characteristic
                let characteristic = Characteristic(connectableCharacteristic: connectableCharacteristic)

                // check if its the Notify characteristic
                if connectableCharacteristic.types.contains(.notify) {
                    let deviceStateRowViewModel = DeviceStateRowViewModel(characteristic: characteristic)
                    self.deviceStateDataSource = deviceStateRowViewModel
                } else {
                    let viewModel = CharacteristicRowViewModel(characteristic: characteristic, {
                        self.selectedCharacteristic(characteristic: characteristic)
                    })
                    self.dataSource.append(viewModel)
                }
            }
            .store(in: &disposables)
    }

    func selectedCharacteristic(characteristic: Characteristic) {
        if characteristic.types.contains(.write) {
            selectWriteCharacteristic = true
        }
    }
}

struct CharacteristicRowViewModel: Identifiable {
    private let characteristic: Characteristic
    let callToAction: CallToAction

    var id: String {
        return characteristic.uuidString
    }

    var name: String {
        for char in Constants.Characteristics.allCases {
            if characteristic.uuidString.uppercased() == char.rawValue.uppercased() {
                return char.displayName
            }
        }

        return characteristic.uuidString
    }

    var types: String {
        var str = ""
        for type in characteristic.types {
            switch type {
            case .read:
                str = str + "READ "
            case .write:
                str = str + "WRITE "
            case .notify:
                str = str + "NOTIFY "
            }
        }
        return str
    }


    init(characteristic: Characteristic, _ callToAction: CallToAction = nil) {
        self.characteristic = characteristic
        self.callToAction = callToAction
    }
}

struct DeviceStateRowViewModel: Identifiable {
    private let characteristic: Characteristic

    var id: String {
        return characteristic.uuidString
    }

    var state: String? {
        if let value = characteristic.characteristicValue,
            let stringValue = String(data: value, encoding: .utf8)
        {
            switch stringValue {
            case "False":
                return "Waiting for new schedule"
            case "True":
                return "Timer Scheduled"
            default:
                return nil
            }
        } else {
            return nil
        }
    }

    init(characteristic: Characteristic) {
        self.characteristic = characteristic
    }
}
