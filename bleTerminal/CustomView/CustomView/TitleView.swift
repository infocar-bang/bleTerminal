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
    @IBOutlet weak var disconnectionButton: UIButton!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var dataTypeButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    
    var onDidTapBackButton: (() -> Void)?
    var onDidTapConnectionButton: (() -> Void)?
    var onDidTapDisconnectionButton: (() -> Void)?
    var onDidTapScanButton: (() -> Void)?
    var onDidTapStopButton: (() -> Void)?
    var onDidTapDataTypeButton: ((ReceivedDataType) -> Void)?
    var onDidTapClearButton: (() -> Void)?
    
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
    
    func initView(from viewControllerName: String, peerName: String? = nil) {
        switch viewControllerName {
        case "Main":
            self.stackView.layoutMargins = UIEdgeInsets(top: .zero, left: 10, bottom: .zero, right: .zero)
            self.stackView.isLayoutMarginsRelativeArrangement = true
            self.scanButton.isHidden = false
            self.menuButton.isHidden = false
            
            let menuItems = [
                UIAction(title: "Settings", handler: { _ in }),
                UIAction(title: "View More", handler: { _ in })
            ]
            self.menuButton.showsMenuAsPrimaryAction = true
            self.menuButton.menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
            
        case "Terminal":
            self.backButton.isHidden = false
            self.connectionStateLabel.isHidden = false
            self.connectionButton.isHidden = false
            self.dataTypeButton.isHidden = false
            self.menuButton.isHidden = false
            
            if let peerName = peerName {
                self.connectionStateLabel.text = ConnectionState.CONNECTING.titleString + peerName
            }
            
            let dataTypeItems = [
                UIAction(title: "ASCII", handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.onDidTapDataTypeButton?(.ASCII)
                }),
                UIAction(title: "HEX", handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.onDidTapDataTypeButton?(.HEX)
                })
            ]
            self.dataTypeButton.showsMenuAsPrimaryAction = true
            self.dataTypeButton.menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: dataTypeItems)
            
            let menuItems = [
                UIAction(title: "Clear", handler: { [weak self] _ in
                    guard let self = self else { return }
                    self.onDidTapClearButton?()
                }),
                UIAction(title: "Settings", handler: { _ in }),
                UIAction(title: "Send Log file", handler: { _ in }),
                UIAction(title: "View More", handler: { _ in })
            ]
            self.menuButton.showsMenuAsPrimaryAction = true
            self.menuButton.menu = UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
            
        case "Settings", "ViewMore":
            self.backButton.isHidden = false
            self.titleLabel.text = viewControllerName
        default:
            return
        }
        
        [ backButton, connectionButton, disconnectionButton, scanButton, stopButton ].forEach { button in
            button?.addTarget(self, action: #selector(buttonActionHandler), for: .touchUpInside)
        }
    }
    
    @objc func buttonActionHandler(_ sender: UIButton) {
        switch sender {
        case backButton:
            onDidTapBackButton?()
        case connectionButton:
            onDidTapConnectionButton?()
        case disconnectionButton:
            onDidTapDisconnectionButton?()
        case scanButton:
            onDidTapScanButton?()
        case stopButton:
            onDidTapStopButton?()
        default: return
        }
    }
    
    func changeScanState(to state: ScanState) {
        DispatchQueue.main.async {
            switch state {
            case .SCAN:
                self.scanButton.isHidden = true
                self.stopButton.isHidden = false
                self.loadingIndicator.isHidden = false
            case .STOP:
                self.scanButton.isHidden = false
                self.stopButton.isHidden = true
                self.loadingIndicator.isHidden = true
            }
        }
    }
    
    func changeConnectionState(to state: ConnectionState, peerName: String) {
        DispatchQueue.main.async {
            self.connectionStateLabel.text = state.titleString + peerName
            
            switch state {
            case .CONNECTED:
                self.connectionButton.isHidden = true
                self.disconnectionButton.isHidden = false
            case .DISCONNECTED:
                self.connectionButton.isHidden = false
                self.disconnectionButton.isHidden = true
            case .CONNECTING:
                return
            }
        }
    }
    
    func changeDataType(to type: ReceivedDataType) {
        DispatchQueue.main.async {
            self.dataTypeButton.setTitle(type.stringValue, for: .normal)
        }
    }
}
