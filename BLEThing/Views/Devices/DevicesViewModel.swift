//
//  DevicesViewModel.swift
//  BLEThing
//
//  Created by Nisum on 30-03-20.
//

import Foundation
import Combine

class DevicesViewModel: ObservableObject, Identifiable {

    @Published var dataSource: [DeviceRowViewModel] = []

    private var disposables = Set<AnyCancellable>()

    var client: Client!

    init(client: Client = Client()) {
        _ = client.transport.discoveredPeripheralsPublisher.sink { (connectable) in
            let peripheral = Peripheral(connectable: connectable)
            let viewModel = DeviceRowViewModel(peripheral: peripheral)
            self.dataSource.append(viewModel)
        }
        .store(in: &disposables)
    }
}

struct DeviceRowViewModel: Identifiable {
    private let peripheral: Peripheral
    var id: String {
        return peripheral.uuid
    }

    init(peripheral: Peripheral) {
        self.peripheral = peripheral
    }
}
