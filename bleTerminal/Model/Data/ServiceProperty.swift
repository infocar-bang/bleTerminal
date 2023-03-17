//
//  Service.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/16.
//

import Foundation
import CoreBluetooth

class ServiceProperty {
    let characteristic: CBCharacteristic
    let role: String
    let uuid: String
    var isSelected: Bool

    init(characteristic: CBCharacteristic, isSelected: Bool) {
        self.characteristic = characteristic
        self.uuid = characteristic.uuid.uuidString
        self.isSelected = isSelected
        
        if characteristic.properties.contains(.read) {
            self.role = "Read"
        } else if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
            self.role = "Write"
        } else {
            self.role = "nil"
        }
    }
}

extension ServiceProperty: Equatable {
    static func ==(lhs: ServiceProperty, rhs: ServiceProperty) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
