//
//  TitleView.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/09.
//

import UIKit

class TitleView: UIView {
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connectionStateLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var connectionButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var onDidTapBackButton: (() -> Void)?
    var onDidTapConnectionButton: (() -> Void)?
    var onDidTapScanButton: (() -> Void)?
    var onDidTapStopButton: (() -> Void)?
    var onDidTapMenuButton: (() -> Void)?
    
    var navigationController: UINavigationController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        loadNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        loadNib()
    }
    
    static var nibName: String {
        get {
            return String(describing: type(of: self))
        }
    }
    
    func loadNib() {
        subviews.forEach({ $0.removeFromSuperview() })
        let nibName = String(describing: type(of: self))
        
        guard Bundle(for: self.classForCoder).path(forResource: nibName, ofType: "nib") != nil else { return }
        guard let view = Bundle(for: self.classForCoder).loadNibNamed(nibName, owner: self, options: nil)?.first(where: { $0 is UIView }) as? UIView else { return }
        
        view.frame = bounds
        addSubview(view)
        backgroundColor = .clear
    }
    
    
    func initView(from viewController: String) {
        switch viewController {
        case "MainViewController":
            self.stackView.layoutMargins = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: .zero)
            self.stackView.isLayoutMarginsRelativeArrangement = true
            self.connectionStateLabel.isHidden = true
            self.backButton.isHidden = true
            self.connectionButton.isHidden = true
            self.scanButton.isHidden = true
            
        default:
            return
        }
        
        [ backButton, connectionButton, scanButton, stopButton, menuButton ].forEach { button in
            button?.addTarget(self, action: #selector(buttonActionHandler), for: .touchUpInside)
        }
    }
    
    func setButtonAction(backButtonAction: (() -> Void)? = nil,
                         connectionButtonAction: (() -> Void)? = nil,
                         scanButtonAction: (() -> Void)? = nil,
                         stopButtonAction: (() -> Void)? = nil,
                         menuButtonAction: (() -> Void)? = nil) {
        
   
        self.onDidTapBackButton = backButtonAction
        self.onDidTapConnectionButton = connectionButtonAction
        self.onDidTapScanButton = scanButtonAction
        self.onDidTapStopButton = stopButtonAction
        self.onDidTapMenuButton = menuButtonAction
    }
    
    @objc func buttonActionHandler(_ sender: UIButton) {
        switch sender {
        case backButton:
            onDidTapBackButton?()
            self.navigationController?.popViewController(animated: true)
        case connectionButton:
            onDidTapConnectionButton?()
        case scanButton:
            self.stopButton.isHidden = false
            self.scanButton.isHidden = true
            self.loadingIndicator.isHidden = false
            onDidTapScanButton?()
        case stopButton:
            self.stopButton.isHidden = true
            self.scanButton.isHidden = false
            self.loadingIndicator.isHidden = true
            onDidTapStopButton?()
        case menuButton:
            onDidTapMenuButton?()
        default: return
        }
    }
}
