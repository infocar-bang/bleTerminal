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
    
    var onDidConnectPeripheral: ((CBPeripheral) -> Void)?
    var onDidFailToConnectPeripheral: ((CBPeripheral, Error?) -> Void)?
    var onDidDisconnectPeripheral: ((CBPeripheral, Error?) -> Void)?
    
    var onDidDiscoverCharacteristics: (([CBCharacteristic]?, Error?) -> Void)?
    
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
    
    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral)
    }
    
    func disconnect(from peripheral: CBPeripheral) {
        centralManager.cancelPeripheralConnection(peripheral)
    }
}

// MARK: - CBCentralManagerDelegate
extension BleManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print(#file, #function, central.state.rawValue)
        switch central.state {
        case .poweredOff: return
        case .poweredOn: startScan()
        case .resetting: return
        case .unauthorized:
            // TODO: 사용자에게 권한부여할 것을 요청
            return
        case .unknown: return
        case .unsupported: return
        default: return
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.onDidDiscoverPeripheral?(peripheral, RSSI)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print(#file, #function, "didConnect")
        self.onDidConnectPeripheral?(peripheral)
        
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print(#file, #function, "didFailToConnect")
        self.onDidFailToConnectPeripheral?(peripheral, error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print(#file, #function, "didDisconnect")
        self.onDidDisconnectPeripheral?(peripheral, error)
    }
}

// MARK: - CBPeripheralDelegate
extension BleManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        services.forEach { service in
            print(#file, #function, service, service.uuid.uuidString)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        self.onDidDiscoverCharacteristics?(service.characteristics, error)
        
//        guard let characteristics = service.characteristics else { return }
//        characteristics.forEach { characteristic in
//            print(#function, characteristic)
//            peripheral.readValue(for: characteristic)
//        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value else { return }

        var string = ""
        value.forEach { uint8 in
            string += String(format: "%02X ", uint8)
        }
        print(#function, string)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value else { return }

        var string = ""
        value.forEach { uint8 in
            string += String(format: "%02X ", uint8)
        }
        print(#function, string)
    }
}
