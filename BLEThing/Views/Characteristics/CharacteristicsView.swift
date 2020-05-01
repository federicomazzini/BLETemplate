//
//  CharacteristicsView.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import SwiftUI

struct CharacteristicsView: View {
    @ObservedObject var viewModel: CharacteristicsViewModel

    init(viewModel: CharacteristicsViewModel = CharacteristicsViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        let navigation = NavigationLink(
            destination: WriteToCharacteristicView(viewModel: WriteToCharacteristicViewModel()),
            isActive: $viewModel.selectWriteCharacteristic
        ) { EmptyView() }.isDetailLink(false)

        return
            VStack {
                navigation
                List {
                    if viewModel.dataSource.isEmpty {
                        emptySection
                    } else {
                        deviceStateSection
                        characteristicsSection
                    }
                }
                .listStyle(GroupedListStyle())
                .navigationBarTitle("Discovered Characteristics", displayMode: .inline)
        }
    }

    var characteristicsSection: some View {
        Section {
            ForEach(viewModel.dataSource, content: CharacteristicRowView.init(viewModel:))
        }
    }

    var deviceStateSection: some View {
        Section(header: Text("Device State")) {
            DeviceStateRowView.init(viewModel: viewModel.deviceStateDataSource)
        }
    }

    var emptySection: some View {
      Section {
        Text("No results")
          .foregroundColor(.gray)
      }
    }

}

//struct CharacteristicsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CharacteristicsView()
//    }
//}
