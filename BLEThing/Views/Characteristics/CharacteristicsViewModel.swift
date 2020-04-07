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
    @Published var selectWriteCharacteristic: Bool = false

    private var disposables = Set<AnyCancellable>()

    var client: Client!

    init(client: Client = Client()) {
        self.client = client
        
        // get discovered characteristics and update dataSource
        _ = client.transport.discoveredCharacteristicsPublisher
            .sink { (connectableCharacteristic) in
                let characteristic = Characteristic(connectableCharacteristic: connectableCharacteristic)
                let viewModel = CharacteristicRowViewModel(characteristic: characteristic, {
                    self.selectedCharacteristic(characteristic: characteristic)
                })
                self.dataSource.append(viewModel)
            }
            .store(in: &disposables)
    }

    func selectedCharacteristic(characteristic: Characteristic) {
        if characteristic.type == .write {
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
