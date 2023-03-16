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
    var responseContent: Observable<String> = Observable("")
    var isAutoScroll: Observable<Bool> = Observable(false)
    
    let peer: Peer
    var characteristics: [CBCharacteristic] = []
    var receivedString: String = ""
    
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
            }
        }
        
        self.bleManager.onDidReceivedMessage = { [weak self] data, error in
            guard let self = self else { return }
            if let error = error {
                print(#file, #function, error.localizedDescription)
                return
            }
            guard let data = data else { return }
            if let string = String(bytes: data, encoding: .utf8) {
                self.receivedString += string
            }
            
            if self.checkEndBytes(data: data) == true {
                self.receivedString.removeLast(2)
                self.responseContent.value += "[\(Date().formatted().description)] \(self.receivedString)\n"
                self.receivedString = ""
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
    
    func changeAutoScrollOption() {
        self.isAutoScroll.value = !self.isAutoScroll.value
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
        if writeCharacteristic == nil { return }
        
        // TerminalViewController의 TableView에 노출되는 보낸 명령어 리스트 추가
        self.commands.value.append(command)
        
        // Write Command
        self.peer.peripheral.writeValue(data, for: writeCharacteristic!, type: .withResponse)
        self.peer.peripheral.delegate = self.bleManager
    }
    
    private func checkEndBytes(data: Data) -> Bool {
        if data.count < 2 { return false }
        
        let lastTwoBytes = data.suffix(2)
        let targetBytes: [UInt8] = [0x0d, 0x3e]
        
        return lastTwoBytes.elementsEqual(targetBytes)
    }
}
