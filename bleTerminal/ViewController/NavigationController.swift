//
//  NavigationController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/09.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationBar.isHidden = true
    }
}
