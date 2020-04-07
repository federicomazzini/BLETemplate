//
//  WriteToCharacteristicViewModel.swift
//  BLEThing
//
//  Created by Nisum on 05-04-20.
//

import Foundation
import Combine
import Combine

class WriteToCharacteristicViewModel: ObservableObject, Identifiable {

    private var disposables = Set<AnyCancellable>()

    var client: Client!

    init(client: Client = Client()) {
        self.client = client
    }

    func setTime(seconds: UInt) {
        self.client.transport.writeTime(seconds)
    }
}
