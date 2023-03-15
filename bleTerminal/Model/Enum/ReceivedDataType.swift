//
//  ReceivedDataType.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/15.
//

import Foundation

enum ReceivedDataType {
    case ASCII
    case HEX
    
    var stringValue: String {
        switch self {
        case .ASCII:
            return "ASCII"
        case .HEX:
            return "HEX"
        }
    }
}
