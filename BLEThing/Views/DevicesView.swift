//
//  DevicesView.swift
//  BLEThing
//
//  Created by Nisum on 05-03-20.
//

import SwiftUI

struct DevicesView: View {
    let viewModel: DevicesViewModel = DevicesViewModel()

    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesView()
    }
}
