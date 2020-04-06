//
//  ServicesViewModel.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import Foundation
import Combine

class ServicesViewModel: ObservableObject, Identifiable {

    @Published var dataSource: [ServiceRowViewModel] = []

    private var disposables = Set<AnyCancellable>()

    var client: Client!

    init(client: Client = Client()) {
        // get discovered services and update dataSource
        _ = client.transport.discoveredServicesPublisher
            .sink { (service) in
                let service = Service(connectableService: service)
                let viewModel = ServiceRowViewModel(service: service, {
                    // subscribe to service
                })
                self.dataSource.append(viewModel)
            }
            .store(in: &disposables)
    }
}

struct ServiceRowViewModel: Identifiable {
    private let service: Service
    let callToAction: CallToAction

    var id: String {
        return service.uuidString
    }

    init(service: Service, _ callToAction: CallToAction = nil) {
        self.service = service
        self.callToAction = callToAction
    }
}
