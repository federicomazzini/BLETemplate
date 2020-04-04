//
//  DevicesView.swift
//  BLEThing
//
//  Created by Nisum on 05-03-20.
//

import SwiftUI
import Combine

struct DevicesView: View {
    @ObservedObject var viewModel = DevicesViewModel()

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
            ForEach(viewModel.dataSource, content: DeviceRow.init(viewModel:))
        }
    }

    var emptySection: some View {
      Section {
        Text("No results")
          .foregroundColor(.gray)
      }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
