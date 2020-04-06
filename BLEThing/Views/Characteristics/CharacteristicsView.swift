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
        List {
            if viewModel.dataSource.isEmpty {
                emptySection
            } else {
                devicesSection
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Searching Characteristics")
    }

    var devicesSection: some View {
        Section {
            ForEach(viewModel.dataSource, content: CharacteristicRowView.init(viewModel:))
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
