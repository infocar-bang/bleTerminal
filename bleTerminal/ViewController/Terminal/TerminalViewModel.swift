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
    var receivedData: Observable<String> = Observable("")
    
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
            self.characteristics.append(contentsOf: characteristics)
            characteristics.forEach { characteristic in
                self.peer.peripheral.setNotifyValue(true, for: characteristic)
                self.receivedData.value += characteristic.description + "\n"
            }
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
        guard let command = command else { return }
        
        let trimmedCommand = command.trimmingCharacters(in: .whitespaces) + "\r"
        guard trimmedCommand.isEmpty == false,
              let data = trimmedCommand.data(using: .utf8) else { return }
        
        // TODO: Charateristic 선택 화면 구현
        let writeUUID = CBUUID(string: "FFF2")
        var writeCharacteristic: CBCharacteristic?
        self.characteristics.forEach { characteristic in
            if characteristic.uuid == writeUUID {
                writeCharacteristic = characteristic
            }
        }
        
        if writeCharacteristic == nil {
            return
        }
        
        // TerminalViewController의 TableView에 노출되는 보낸 명령어 리스트 추가
        self.commands.value.append(trimmedCommand)
        
        // Write Command
        self.peer.peripheral.writeValue(data, for: writeCharacteristic!, type: .withResponse)
        self.peer.peripheral.delegate = self.bleManager
    }
}
