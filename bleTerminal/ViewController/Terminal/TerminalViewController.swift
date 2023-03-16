//
//  TerminalViewController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/10.
//

import UIKit

class TerminalViewController: UIViewController {
    @IBOutlet weak var titleView: TitleView!
    
    @IBOutlet weak var terminalView: UIScrollView!
    @IBOutlet weak var terminalViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var responseLabel: UILabel!
    
    @IBOutlet weak var interactionContainer: UIView!
    @IBOutlet weak var checkBoxContainer: UIStackView!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var selectPropertiesButton: UIButton!
    @IBOutlet weak var commandTextField: UITextField!
    @IBOutlet weak var sendCommandButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var coverView: UIView!
    
    @IBOutlet weak var macroContainer: UIView!
    
    var vm: TerminalViewModel!
    
    var dto: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initTableViewCell()
        setBinding()
    
        vm.connectToPeer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // keyboard observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // try to connect with peer
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // keyboard observer 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func initView() {
        self.titleView.initView(from: self.nameString, peerName: self.vm.peer.name)
        
        self.titleView.onDidTapBackButton = { [weak self] in
            guard let self = self else { return }
            self.vm.disconnectFromPeer()
            self.navigationController?.popViewController(animated: true)
        }
        
        self.titleView.onDidTapConnectionButton = { [weak self] in
            guard let self = self else { return }
            self.vm.connectToPeer()
        }
        
        self.titleView.onDidTapDisconnectionButton = { [weak self] in
            guard let self = self else { return }
            self.vm.disconnectFromPeer()
        }
        
        self.titleView.onDidTapDataTypeButton = { [weak self] type in
            guard let self = self else { return }
            self.vm.setReceivedDataType(type)
        }
        
        [ view, checkBoxContainer ].forEach { view in
            view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler)))
        }
        
        [ selectPropertiesButton, sendCommandButton ].forEach { button in
            button?.addTarget(self, action: #selector(buttonActionHandler), for: .touchUpInside)
        }
    }
    
    func initTableViewCell() {
        let cellNib = UINib(nibName: "TerminalCommandTableViewCell", bundle: Bundle(for: self.classForCoder))
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    func setBinding() {
        self.vm.connectionState.bind { [weak self] state in
            guard let self = self else { return }
            self.titleView.changeConnectionState(to: state, peerName: self.vm.peer.name)
            
            switch state {
            case .CONNECTING:
                guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "TerminalPopupViewController") as? TerminalPopupViewController else { return }
                popupVC.modalPresentationStyle = .overFullScreen
                self.present(popupVC, animated: false)
                
            case .CONNECTED:
                self.presentedViewController?.dismiss(animated: false)
                
            case .DISCONNECTED:
                return
            }
        }
        
        self.vm.receivedDataType.bind { [weak self] type in
            guard let self = self else { return }
            self.titleView.changeDataType(to: type)
        }
        
        self.vm.receivedData.bind { [weak self] string in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.responseLabel.text = string
            }
        }
        
        self.vm.commands.bind { [weak self] commands in
            guard let self = self else { return }
            self.dto = commands
            self.tableView.reloadData()
            
            // 마지막에 작성된 Command의 셀로 포커스 이동
            let numberOfRows = self.tableView.numberOfRows(inSection: .zero)
            if numberOfRows > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: numberOfRows - 1, section: .zero), at: .bottom, animated: true)
            }
        }
    }
    
    @objc func tapGestureHandler(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.view {
        case view:
            view.endEditing(true)
        case checkBoxContainer:
            // TODO: vm에 탭 됐다고 전달 -> vm 에서 관련 변수 수정 -> observe로 확인 후 변경(아래 코드는 이동해야함)
            self.checkBoxImageView.image = UIImage(systemName: "checkmark.square.fill")
        default: return
        }
    }
    
    @objc func buttonActionHandler(_ sender: UIButton) {
        switch sender {
        case selectPropertiesButton:
            return
        case sendCommandButton:
            self.vm.sendCommand(self.commandTextField.text)
            self.commandTextField.text = ""
        default:
            return
        }
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if self.tableView.isHidden == false {
                // Constraints: termialView.bottom == ineractionContainer.top
                // termialView.height.constraint를 조절하여 interactionContainer의 위치를 keyboard 상단에 위치할 수 있도록 조절
                self.terminalViewHeightContraint.constant = keyboardFrame.height - macroContainer.frame.height - tableView.frame.height + 10
                self.tableView.isHidden = true
                self.coverView.isHidden = false
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.terminalViewHeightContraint.constant = 0
        self.tableView.isHidden = false
        self.coverView.isHidden = true
        
        let numberOfRows = self.tableView.numberOfRows(inSection: .zero)
        if numberOfRows > 0 {
            self.tableView.scrollToRow(at: IndexPath(row: numberOfRows - 1, section: .zero), at: .bottom, animated: true)
        }
    }
}

// MARK: - UITextFieldDelegate
extension TerminalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDataSource
extension TerminalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dto.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TerminalCommandTableViewCell else {
            return UITableViewCell()
        }
        cell.set(command: self.dto[indexPath.row])
        return cell
    }
}
