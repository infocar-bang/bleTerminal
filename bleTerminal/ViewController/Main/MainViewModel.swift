//
//  MainViewModel.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/13.
//

import Foundation
import CoreBluetooth

class MainViewModel: ObservableObject {
    @Published var peers: [PeripheralDevice] = []

    func startScan() {
//        if centralManager.state == .poweredOn {
//            self.centralManager.scanForPeripherals(withServices: nil)
//        }
    }
    
    func stopScan() {
//        self.centralManager.stopScan()
    }
}
