//
//  PeripheralDevice.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/13.
//

import Foundation
import CoreBluetooth

struct PeripheralDevice: Hashable {
    let name: String
    let uuid: String
    let rssi: NSNumber
    
    init(peripheral: CBPeripheral, rssi: NSNumber) {
        self.name = peripheral.name ?? "Unnamed"
        self.uuid = peripheral.identifier.uuidString
        self.rssi = rssi
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func ==(lhs: PeripheralDevice, rhs: PeripheralDevice) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
