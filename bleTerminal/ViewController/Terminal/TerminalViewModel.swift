//
//  TerminalViewModel.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/14.
//

import Foundation
import CoreBluetooth

class TerminalViewModel: BaseViewModel {
    let bleManager = BleManager.shared
    var connectionState: Observable<ConnectionState> = Observable(.DISCONNECTED)
    var commands: Observable<[String]> = Observable([])
    var receivedDataType: Observable<ReceivedDataType> = Observable(.ASCII)
    
    let peer: Peer
    
    var characteristics: [CBCharacteristic] = []
    
    init(peer: Peer) {
        self.peer = peer
        
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
        
        self.bleManager.onDidDiscoverCharacteristics = { [weak self] characteristics, error in
            guard let self = self else { return }
            if let error = error {
                print(#file, #function, error.localizedDescription)
                return
            }
            guard let characteristics = characteristics else { return }
            self.characteristics = characteristics
        }
    }
    
    func setReceivedDataType(_ type: ReceivedDataType) {
        self.receivedDataType.value = type
    }
    
    func connectToPeer() {
        print(#file, #function, "connect")
        self.connectionState.value = .CONNECTING
        self.bleManager.connect(to: self.peer.peripheral)
    }
    
    func disconnectFromPeer() {
        print(#file, #function, "disconnect")
        self.bleManager.disconnect(from: self.peer.peripheral)
    }
    
    func sendCommand(_ command: String?) {
        guard connectionState.value == .CONNECTED else { return }
        guard let command = command,
              command.isEmpty == false,
              let data = command.data(using: .utf8) else { return }
         
        // TerminalViewController의 TableView에 노출되는 보낸 명령어 리스트 추가
        self.commands.value.append(command)
        
        //
        self.peer.peripheral.writeValue(data, for: self.characteristics[0], type: .withResponse)
        self.peer.peripheral.delegate = self.bleManager
    }
}
