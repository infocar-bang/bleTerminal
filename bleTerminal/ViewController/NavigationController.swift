//
//  NavigationController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/09.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isHidden = true
        self.interactivePopGestureRecognizer?.isEnabled = false
    }
}
