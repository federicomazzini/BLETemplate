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
    @Published var connected: Bool = false

    private var disposables = Set<AnyCancellable>()

    var client: Client!

    init(client: Client = Client()) {
        self.client = client

        // get discovered peripherals and update dataSource
        _ = client.transport.discoveredPeripheralsPublisher
            .sink { (connectable) in
                let peripheral = Peripheral(connectable: connectable)
                let viewModel = DeviceRowViewModel(peripheral: peripheral, {
                    self.connect(toPeripheral: peripheral)
                })
                self.dataSource.append(viewModel)
            }
            .store(in: &disposables)

        // verify if connected and publish "connected = true"
        _ = client.transport.connectedPeripheralPublisher
            .sink(receiveCompletion: { _ in
                fatalError("fatalError: connectedPeripheralPublisher completetion.")
            }, receiveValue: { state in
                switch state {
                case .connected:
                    print("DevicesViewModel: device connected")
                    self.connected = true
                case .disconnected:
                    print("DevicesViewModel: device disconnected")
                    self.connected = false
                }
            })
            .store(in: &disposables)
    }

    func connect(toPeripheral peripheral: Peripheral) {
        client.transport.connect(toConnectable: peripheral)
    }

    func disconnect() {
        client.transport.cancelConnection()
    }
}

struct DeviceRowViewModel: Identifiable {
    private let peripheral: Peripheral
    let callToAction: CallToAction

    var id: String {
        return peripheral.uuid
    }

    init(peripheral: Peripheral, _ callToAction: CallToAction = nil) {
        self.peripheral = peripheral
        self.callToAction = callToAction
    }
}
