//
//  ServicesView.swift
//  BLEThing
//
//  Created by Nisum on 04-04-20.
//

import SwiftUI

struct ServicesView: View {
    @ObservedObject var viewModel: ServicesViewModel

    init(viewModel: ServicesViewModel = ServicesViewModel()) {
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
        .navigationBarTitle("Searching Services")
    }

    var devicesSection: some View {
        Section {
            ForEach(viewModel.dataSource, content: ServiceRowView.init(viewModel:))
        }
    }

    var emptySection: some View {
      Section {
        Text("No results")
          .foregroundColor(.gray)
      }
    }

}

//struct ServicesView_Previews: PreviewProvider {
//    static var previews: some View {
//        ServicesView()
//    }
//}
