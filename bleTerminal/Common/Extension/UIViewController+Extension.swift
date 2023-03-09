//
//  UIViewController+Extension.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/09.
//

import Foundation
import UIKit

extension UIViewController {
    var nameString: String {
        return String(describing: self.classForCoder)
    }
}
