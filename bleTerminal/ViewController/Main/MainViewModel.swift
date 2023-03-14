//
//  MainViewModel.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/13.
//

import Foundation

class MainViewModel: BaseViewModel {
    let bleManager = BleManager.shared
    var peers: Observable<[Peer]> = Observable([])
    var scanState: Observable<ScanState> = Observable(.STOP)
    
    var timerWorkItem: DispatchWorkItem?
    
    override init() {
        super.init()
        
        setHandler()
        registTimer()
    }
    
    private func setHandler() {
        bleManager.onDidDiscoverPeripheral = { [weak self] peripheral, rssi in
            guard let self = self else { return }
            let peripheralDevice = Peer(peripheral: peripheral, rssi: rssi)
            if self.peers.value.contains(peripheralDevice) == false {
                print(#file, #function, peripheralDevice)
                
                self.peers.value.append(peripheralDevice)
                self.peers.value.sort { $0.rssi.floatValue > $1.rssi.floatValue }
            }
        }
    }
    
    private func registTimer() {
        self.timerWorkItem = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            self.bleManager.stopScan()
            self.scanState.value = .STOP
        }
    }
    
    func startScan() {
        self.scanState.value = .SCAN
        self.peers.value = []
        registTimer()
        
        self.bleManager.startScan()
        
        guard let timerWorkItem = self.timerWorkItem else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + 5, execute: timerWorkItem)
    }
    
    func stopScan() {
        self.bleManager.stopScan()
        if self.scanState.value == .SCAN {
            self.scanState.value = .STOP
        }
        self.timerWorkItem?.cancel()
    }
}
