//
//  TerminalViewModel.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/14.
//

import Foundation

class TerminalViewModel: BaseViewModel {
    let bleManager = BleManager.shared
    var connectionState: Observable<ConnectState> = Observable(.DISCONNECTED)
    
    override init() {
        super.init()
        
        setHandler()
    }
    
    private func setHandler() {
        self.bleManager.onDidConnectPeripheral = { [weak self] peripheral in
            guard let self = self else { return }
            self.connectionState.value = .CONNECTED
        }
        
        self.bleManager.onDidFailToConnectPeripheral = { [weak self] peripheral, error in
            guard let self = self else { return }
            self.connectionState.value = .DISCONNECTED
            if let error = error {
                print(#file, #function, error.localizedDescription)
                return
            }
        }
        
        self.bleManager.onDidDisconnectPeripheral = { [weak self] peripheral, error in
            guard let self = self else { return }
            self.connectionState.value = .DISCONNECTED
            if let error = error {
                print(#file, #function, error.localizedDescription)
                return
            }
        }
    }
    
    
    func connect(with peer: Peer) {
        print(#file, #function, "connect")
        self.connectionState.value = .CONNECTING
        self.bleManager.connect(with: peer.peripheral)
    }
    
    func disconnect(with peer: Peer) {
        print(#file, #function, "disconnect")
        self.bleManager.disconnect(with: peer.peripheral)
    }
}
