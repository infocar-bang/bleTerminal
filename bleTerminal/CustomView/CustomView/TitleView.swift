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
    @IBOutlet weak var dataTypeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    
    var onDidTapBackButton: (() -> Void)?
    var onDidTapConnectionButton: (() -> Void)?
    var onDidTapScanButton: (() -> Void)?
    var onDidTapStopButton: (() -> Void)?
    var onDidTapDataTypeButton: (() -> Void)?
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
    
    func initView(from viewControllerName: String, navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        switch viewControllerName {
        case "Main":
            self.stackView.layoutMargins = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: .zero)
            self.stackView.isLayoutMarginsRelativeArrangement = true
            self.connectionStateLabel.isHidden = true
            self.backButton.isHidden = true
            self.connectionButton.isHidden = true
            self.scanButton.isHidden = true
            self.dataTypeButton.isHidden = true
            
            let menuItems = [
                UIAction(title: "Settings", handler: { [weak self] _ in
                    guard let self = self else { return }
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsViewController")
                    self.navigationController?.pushViewController(settingsViewController, animated: true)
                }),
                UIAction(title: "View More", handler: { _ in })
            ]
            self.menuButton.showsMenuAsPrimaryAction = true
            self.menuButton.menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
            
        case "Terminal":
            self.loadingIndicator.isHidden = true
            self.scanButton.isHidden = true
            self.stopButton.isHidden = true
            
            let commandTypeItems = [
                UIAction(title: "ASCII", handler: { _ in }),
                UIAction(title: "HEX", handler: { _ in })
            ]
            self.dataTypeButton.showsMenuAsPrimaryAction = true
            self.dataTypeButton.menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: commandTypeItems)
            
            let menuItems = [
                UIAction(title: "Clear", handler: { _ in }),
                UIAction(title: "Settings", handler: { _ in }),
                UIAction(title: "Send Log file", handler: { _ in }),
                UIAction(title: "View More", handler: { _ in })
            ]
            self.menuButton.showsMenuAsPrimaryAction = true
            self.menuButton.menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
            
        case "Settings", "ViewMore":
            self.titleLabel.text = viewControllerName
            self.connectionStateLabel.isHidden = true
            self.loadingIndicator.isHidden = true
            self.connectionButton.isHidden = true
            self.scanButton.isHidden = true
            self.stopButton.isHidden = true
            self.dataTypeButton.isHidden = true
            self.menuButton.isHidden = true
        default:
            return
        }
        
        [ backButton, connectionButton, scanButton, stopButton, menuButton ].forEach { button in
            button?.addTarget(self, action: #selector(buttonActionHandler), for: .touchUpInside)
        }
    }
    
    func setBind(vm: BaseViewModel) {
        if let vm = vm as? MainViewModel {
            vm.scanState.bind { [weak self] bool in
                print(#function, "changeScanState: \(bool)")
                
                guard let self = self else { return }
                if bool == true {
                    DispatchQueue.main.async {
                        self.processScanState()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.processStopState()
                    }
                }
            }
        }
    }
    
    func setButtonAction(backButtonAction: (() -> Void)? = nil,
                         connectionButtonAction: (() -> Void)? = nil,
                         scanButtonAction: (() -> Void)? = nil,
                         stopButtonAction: (() -> Void)? = nil,
                         dataTypeButtonAction: (() -> Void)? = nil,
                         menuButtonAction: (() -> Void)? = nil) {
        
        self.onDidTapBackButton = backButtonAction
        self.onDidTapConnectionButton = connectionButtonAction
        self.onDidTapScanButton = scanButtonAction
        self.onDidTapStopButton = stopButtonAction
        self.onDidTapDataTypeButton = dataTypeButtonAction
        self.onDidTapMenuButton = menuButtonAction
    }
    
    @objc func buttonActionHandler(_ sender: UIButton) {
        switch sender {
        case backButton:
            onDidTapBackButton?()
            guard let navigationController = self.navigationController else { return }
            navigationController.popViewController(animated: true)
        case connectionButton:
            onDidTapConnectionButton?()
        case scanButton:
            self.processScanState()
            onDidTapScanButton?()
        case stopButton:
            self.processStopState()
            onDidTapStopButton?()
        case dataTypeButton:
            onDidTapDataTypeButton?()
        case menuButton:
            onDidTapMenuButton?()
        default: return
        }
    }
    
    private func processScanState() {
        self.stopButton.isHidden = false
        self.scanButton.isHidden = true
        self.loadingIndicator.isHidden = false
    }
    
    private func processStopState() {
        self.stopButton.isHidden = true
        self.scanButton.isHidden = false
        self.loadingIndicator.isHidden = true
    }
}
