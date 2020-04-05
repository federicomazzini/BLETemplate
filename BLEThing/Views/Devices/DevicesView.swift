//
//  DevicesView.swift
//  BLEThing
//
//  Created by Nisum on 05-03-20.
//

import SwiftUI
import Combine

struct DevicesView: View {
    @ObservedObject var viewModel: DevicesViewModel

    init(viewModel: DevicesViewModel = DevicesViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
      NavigationView {
        List {
          if viewModel.dataSource.isEmpty {
            emptySection
          } else {
            devicesSection
          }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Searching Devices")
      }
    }

    var devicesSection: some View {
        Section {
//            NavigationLink(destination: ServicesView(viewModel: ServicesViewModel(client: self.viewModel.client))) {
            ForEach(viewModel.dataSource, content: DeviceRowView.init(viewModel:))
        }
    }

    var emptySection: some View {
      Section {
        Text("No results")
          .foregroundColor(.gray)
      }
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        DevicesView()
//    }
//}