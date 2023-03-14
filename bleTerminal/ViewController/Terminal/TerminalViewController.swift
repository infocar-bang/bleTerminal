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
    
    let vm = TerminalViewModel()
    var peer: Peer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initTableViewCell()
        setBinding()
    
        vm.connect(with: peer)
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
        guard let navigationControllerInstance = self.navigationController else { return }
        self.titleView.initView(from: self.nameString, navigationController: navigationControllerInstance, peerName: peer.name)
        self.titleView.setButtonAction(
            backButtonAction: { [weak self] in
                guard let self = self else { return }
                // try to disconnect with peer
                self.vm.disconnect(with: self.peer)
            }, connectionButtonAction: { [weak self] in
                guard let self = self else { return }
                // try to connect with peer
                self.vm.connect(with: self.peer)
            }, disconnectionButtonAction: { [weak self] in
                guard let self = self else { return }
                // try to connect with peer
                self.vm.disconnect(with: self.peer)
            }, menuButtonAction: {
                
            }
        )
        
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
        titleView.setBind(vm: vm, peerName: peer.name)
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
            // TODO: text field의 text를 vm에 전달 -> vm에서 table view의 data로 저장 -> table view reload
            return
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? TerminalCommandTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.set(command: "yhugvvvvv dfdfadfea e aefakdfjlejalk e akdjf lakjf elakf ekldfafd")
        case 1:
            cell.set(command: "dafeflkajfehjakehfkeahfjkehakjefhkahfkeajhfkehfkeahfkaehfkeh")
        default:
            cell.set(command: "d")
        }
        
        return cell
    }
}
