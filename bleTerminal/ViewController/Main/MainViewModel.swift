//
//  MainViewModel.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/13.
//

import Foundation

class MainViewModel: ObservableObject {
    let bleManager = BleManager.shared
    
    var listener: ((Set<PeripheralDevice>) -> Void)? = nil
    var peers: Set<PeripheralDevice> = [] {
        didSet {
            listener?(peers)
        }
    }

    func startScan() {
        bleManager.startScan()
        bleManager.onDidDiscoverPeripheral = { [weak self] peripheral, rssi in
            guard let self = self else { return }
            
            print(#function, peripheral)
            let peripheralDevice = PeripheralDevice(peripheral: peripheral, rssi: rssi)
            self.peers.insert(peripheralDevice)
        }
    }
    
    func stopScan() {
        bleManager.stopScan()
    }
}
