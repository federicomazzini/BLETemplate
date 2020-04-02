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

    var bleService = CBServiceProvider()

    init() {
        _ = bleService.discoveredPeripheralPublisher.sink { (peripheral) in
            let viewModel = DeviceRowViewModel(peripheral: peripheral)
            self.dataSource.append(viewModel)
        }
        .store(in: &disposables)
    }
}

struct DeviceRowViewModel: Identifiable {
    private let peripheral: Peripheral

    init(peripheral: Peripheral) {
        self.peripheral = peripheral
    }

    var id: String {
        return peripheral.uuid
    }
}
