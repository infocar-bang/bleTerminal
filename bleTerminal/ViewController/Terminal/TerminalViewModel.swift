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
    
    var serviceProperty: Observable<[ServiceProperty]> = Observable([])
    
    let peer: Peer
    var writeCharacteristics: [CBCharacteristic] = []
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
            characteristics.forEach { characteristic in
                let service = ServiceProperty(characteristic: characteristic, isSelected: false)
                if self.serviceProperty.value.contains(service) == false {
                    self.serviceProperty.value.append(service)
                }
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
    
    func getFetchData() {
        self.isAutoScroll.value = UserDefaults.standard.bool(forKey: "AUTO_SCROLL")
        print(#function, self.isAutoScroll.value)
    }
    
    func setReceivedDataType(_ type: ReceivedDataType) {
        self.receivedDataType.value = type
    }
    
    func changeAutoScrollOption() {
        self.isAutoScroll.value = !self.isAutoScroll.value
        UserDefaults.standard.set(self.isAutoScroll.value, forKey: "AUTO_SCROLL")
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
    
    func getServiceOfPeer() {
        self.peer.peripheral.discoverServices(nil)
    }
    
    func changeSelectionProperty(property: ServiceProperty) {
        property.isSelected = !property.isSelected
        
        switch property.role {
        case "Read":
            self.peer.peripheral.setNotifyValue(property.isSelected, for: property.characteristic)
        case "Write":
            if property.isSelected {
                self.writeCharacteristics.append(property.characteristic)
            } else {
                guard let index = self.writeCharacteristics.firstIndex(of: property.characteristic) else { return }
                self.writeCharacteristics.remove(at: index)
            }
        default: return
        }
        
    }
    
    func sendCommand(_ command: String?) {
        guard connectionState.value == .CONNECTED else { return }
        guard let command = command else { return }
        
        let trimmedCommand = command.trimmingCharacters(in: .whitespaces) + "\r"
        guard trimmedCommand.isEmpty == false,
              let data = trimmedCommand.data(using: .utf8) else { return }
        
        // TerminalViewController의 TableView에 노출되는 보낸 명령어 리스트 추가
        self.commands.value.append(command)
        
        // Write Command
        self.writeCharacteristics.forEach { characteristic in
            self.peer.peripheral.writeValue(data, for: characteristic, type: .withResponse)
        }
    }
    
    private func checkEndBytes(data: Data) -> Bool {
        if data.count < 2 { return false }
        
        let lastTwoBytes = data.suffix(2)
        let targetBytes: [UInt8] = [0x0d, 0x3e]
        
        return lastTwoBytes.elementsEqual(targetBytes)
    }
}
