//
//  DeviceRowView.swift
//  BLEThing
//
//  Created by Nisum on 01-04-20.
//

import SwiftUI

struct DeviceRowView: View {

    private let viewModel: DeviceRowViewModel
    private var callToAction: CallToAction = nil

    init(viewModel: DeviceRowViewModel) {
        self.viewModel = viewModel
        self.callToAction = viewModel.callToAction
    }

    var body: some View {
        Button(action: {
            if let callToAction = self.callToAction {
                callToAction()
            }
        }) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.id)
                    .font(.system(size: 16))
            }.padding(4).border(Color.blue).padding(4)
        }
    }
}

#if DEBUG
struct DeviceRow_Previews: PreviewProvider {
    static var previews: some View {
        let peripheral = Peripheral.mockPeripheral
        let viewModel = DeviceRowViewModel(peripheral: peripheral)

        // Display size categories
        return ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
            DeviceRowView(viewModel: viewModel)
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, sizeCategory)
                .previewDisplayName("\(sizeCategory)")
        }
    }
}
#endif
