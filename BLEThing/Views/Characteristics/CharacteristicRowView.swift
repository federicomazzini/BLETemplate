//
//  CharacteristicRowView.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import SwiftUI

struct CharacteristicRowView: View {

    private let viewModel: CharacteristicRowViewModel
    private var callToAction: CallToAction = nil

    init(viewModel: CharacteristicRowViewModel) {
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
                    .lineLimit(1)
                HStack {
                    Text(viewModel.name + ":")
                        .font(.system(size: 14))
                        .lineLimit(1)
                    Text(viewModel.type + " characteristic")
                        .font(.system(size: 14))
                        .lineLimit(1)
                }
            }.padding(4).border(Color.blue).padding(4)
        }
    }
}

#if DEBUG
struct CharacteristicRow_Previews: PreviewProvider {
    static var previews: some View {
        let characteristic = Characteristic.mockCharacteristic
        let viewModel = CharacteristicRowViewModel(characteristic: characteristic)
        // Display size categories
        return ForEach(ContentSizeCategory.allCases, id: \.self) { sizeCategory in
            CharacteristicRowView(viewModel: viewModel)
                .previewLayout(.sizeThatFits)
                .environment(\.sizeCategory, sizeCategory)
                .previewDisplayName("\(sizeCategory)")
        }
    }
}
#endif
