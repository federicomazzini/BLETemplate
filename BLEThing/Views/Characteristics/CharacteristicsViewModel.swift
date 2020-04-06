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

    private var disposables = Set<AnyCancellable>()

    var client: Client!

    init(client: Client = Client()) {
        // get discovered Characteristics and update dataSource
        _ = client.transport.discoveredCharacteristicsPublisher
            .sink { (connectableCharacteristic) in
                let characteristic = Characteristic(connectableCharacteristic: connectableCharacteristic)
                let viewModel = CharacteristicRowViewModel(characteristic: characteristic, {
                    // subscribe to Characteristic
                })
                self.dataSource.append(viewModel)
            }
            .store(in: &disposables)
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
            if characteristic.uuidString == char.rawValue {
                return char.displayName
            }
        }

        return characteristic.uuidString
    }

    var type: String {
        switch characteristic.type {
        case .read:
            return "Read"
        case .write:
            return "Write"
        }
    }


    init(characteristic: Characteristic, _ callToAction: CallToAction = nil) {
        self.characteristic = characteristic
        self.callToAction = callToAction
    }
}
