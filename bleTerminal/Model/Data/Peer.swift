//
//  Peer.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/13.
//

import Foundation
import CoreBluetooth

struct Peer: Hashable {
    let peripheral: CBPeripheral
    let name: String
    let uuid: String
    let rssi: NSNumber
    
    init(peripheral: CBPeripheral, rssi: NSNumber) {
        self.peripheral = peripheral
        self.name = peripheral.name ?? "Unnamed"
        self.uuid = peripheral.identifier.uuidString
        self.rssi = rssi
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func ==(lhs: Peer, rhs: Peer) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
