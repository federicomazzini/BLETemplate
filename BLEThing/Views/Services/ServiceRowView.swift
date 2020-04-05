//
//  ServiceRowView.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import SwiftUI

struct ServiceRowView: View {

    let viewModel: ServiceRowViewModel
    let callToAction: CallToAction = nil

    init(viewModel: ServiceRowViewModel, _ action: (() -> ())? = nil) {
        self.viewModel = viewModel
    }

    var body: some View {
        Button(action: {
            if let callToAction = self.callToAction {
                callToAction()
            }
        }) {
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.id)
                    .padding()
                    .border(Color.blue)
            }
        }
    }
}

#if DEBUG
struct ServiceRow_Previews: PreviewProvider {
    static var previews: some View {
        let peripheral = Peripheral.mockPeripheral
        let viewModel = ServiceRowViewModel(peripheral: peripheral)

        // Display size categories
        return ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
            ServiceRowView(viewModel: viewModel)
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, sizeCategory)
                .previewDisplayName("\(sizeCategory)")
        }
    }
}
#endif
