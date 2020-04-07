//
//  WriteToCharacteristicView.swift
//  BLEThing
//
//  Created by Nisum on 05-04-20.
//

import SwiftUI

struct WriteToCharacteristicView: View {
    @ObservedObject var viewModel: WriteToCharacteristicViewModel
    @State private var selectedMinutes: Int = 0

    let minutes = Array(1...60)

    init(viewModel: WriteToCharacteristicViewModel = WriteToCharacteristicViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            Picker(selection: $selectedMinutes, label: EmptyView()) {
                ForEach(minutes.indices) { index in
                    Text("\(index)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .labelsHidden()

            Button(action: {
                self.viewModel.setTime(seconds: UInt(self.selectedMinutes))
            }) {
                Text("Select")
            }
            .padding(8)
            .border(Color.blue)
        }
        .navigationBarTitle("Select a time")
    }
}

struct WriteToCharacteristicView_Previews: PreviewProvider {
    static var previews: some View {
        WriteToCharacteristicView()
    }
}
