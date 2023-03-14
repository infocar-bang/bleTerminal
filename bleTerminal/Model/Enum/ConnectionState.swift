//
//  ConnectionState.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/14.
//

import Foundation

enum ConnectionState {
    case CONNECTED
    case DISCONNECTED
    case CONNECTING
    
    var titleString: String {
        switch self {
        case .CONNECTED:
            return "Connected With "
        case .DISCONNECTED:
            return "Disconnected From "
        case .CONNECTING:
            return "Connecting To "
        }
    }
}
