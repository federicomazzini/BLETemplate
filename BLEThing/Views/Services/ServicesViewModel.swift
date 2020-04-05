//
//  ServicesViewModel.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import Foundation
import Combine

class ServicesViewModel: ObservableObject, Identifiable {

    @Published var dataSource: [DeviceRowViewModel] = []

    private var disposables = Set<AnyCancellable>()

    var client: Client!

    init(client: Client = Client()) {
        _ = client.transport.connectedPeripheralPublisher
            .sink(receiveCompletion: { _ in
                print("device connected")
            }, receiveValue: { _ in })
    }
}

struct ServiceRowViewModel: Identifiable {
    private let peripheral: Peripheral
    var id: String {
        return peripheral.uuid
    }

    init(peripheral: Peripheral) {
        self.peripheral = peripheral
    }
}
