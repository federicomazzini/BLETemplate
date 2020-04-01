//
//  BLEService.swift
//  BLEThing
//
//  Created by Nisum on 05-03-20.
//

import Foundation

protocol BLEService {

    /// Wait 3 seconds and return discovered peripherals in a stream.
    func scan() -> [Peripheral]
//    func connect(toPeripheral peripheral: Peripheral)
//    func readUptime() -> UInt
//    func writeTime(time: UInt)
//    func readState() -> PeripheralState
}
