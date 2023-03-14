//
//  BleManager.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/13.
//

import Foundation
import CoreBluetooth

class BleManager: NSObject {
    public static let shared = BleManager()
    
    let centralManager = CBCentralManager()
    var onDidDiscoverPeripheral: ((CBPeripheral, NSNumber) -> Void)?
    
    override init() {
        super.init()
        centralManager.delegate = self
    }
    
    func startScan() {
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil)
        }
    }
    
    func stopScan() {
        centralManager.stopScan()
    }
}

// MARK: - CBCentralManagerDelegate
extension BleManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(#function, central.state.rawValue)
        switch central.state {
        case .poweredOff: return
        case .poweredOn:
            centralManager.scanForPeripherals(withServices: nil)
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
