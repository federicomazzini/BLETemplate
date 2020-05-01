//
//  DeviceStateRowView.swift
//  BLEThing
//
//  Created by Nisum on 01-05-20.
//

import SwiftUI

struct DeviceStateRowView: View {

    private let viewModel: DeviceStateRowViewModel?

    init(viewModel: DeviceStateRowViewModel?) {
        self.viewModel = viewModel
    }

    var body: some View {
        Text(viewModel?.state ?? "Checking...")
        .font(.system(size: 16))
        .lineLimit(1)
    }
}

#if DEBUG
struct DeviceStateRow_Previews: PreviewProvider {
    static var previews: some View {
        let characteristic = Characteristic.mockCharacteristic
        let viewModel = DeviceStateRowViewModel(characteristic: characteristic)
        // Display size categories
        return ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
            DeviceStateRowView(viewModel: viewModel)
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, sizeCategory)
                .previewDisplayName("\(sizeCategory)")
        }
    }
}
#endif
