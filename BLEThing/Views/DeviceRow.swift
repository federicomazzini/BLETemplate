//
//  DeviceRow.swift
//  BLEThing
//
//  Created by Nisum on 01-04-20.
//

import SwiftUI

struct DeviceRow: View {

    let viewModel: DeviceRowViewModel

    init(viewModel: DeviceRowViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(viewModel.id)
                .padding()
                .border(Color.blue)
        }
    }
}

#if DEBUG
struct DeviceRow_Previews: PreviewProvider {
    static var previews: some View {
        let peripheral = MockPeripheral()
        let viewModel = DeviceRowViewModel(peripheral: peripheral)

        // Display size categories
        return ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
            DeviceRow(viewModel: viewModel)
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, sizeCategory)
                .previewDisplayName("\(sizeCategory)")
        }
    }
}
#endif
