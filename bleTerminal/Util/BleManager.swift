//
//  BleManager.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/13.
//

import Foundation
import CoreBluetooth

class BleManager: NSObject {
    
    var onDidDiscoverPeripheral: ((CBPeripheral, NSNumber) -> Void)?
    
    override init() {
        super.init()
    }
}

extension BleManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff: return
        case .poweredOn: return
        case .resetting: return
        case .unauthorized: return
        case .unknown: return
        case .unsupported: return
        default: return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.onDidDiscoverPeripheral?(peripheral, RSSI)
    }
}
