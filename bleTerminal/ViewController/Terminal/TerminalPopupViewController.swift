//
//  TerminalPopupViewController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/14.
//

import UIKit

class TerminalPopupViewController: UIViewController {
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    func initView() {
        self.popupView.layer.cornerRadius = 15
        self.popupView.layer.masksToBounds = true
    }
}
