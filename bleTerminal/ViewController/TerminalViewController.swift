//
//  TerminalViewController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/10.
//

import UIKit

class TerminalViewController: UIViewController {
    @IBOutlet weak var titleView: TitleView!
    
    @IBOutlet weak var terminalView: UIView!
    @IBOutlet weak var interactionContainer: UIView!
    @IBOutlet weak var macroContainer: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var terminalViewHeightContraint: NSLayoutConstraint!
    
    @IBOutlet weak var checkBoxContainer: UIStackView!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // keyboard observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // keyboard observer 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func initView() {
        guard let navigationControllerInstance = self.navigationController else { return }
        self.titleView.initView(from: self.nameString, navigationController: navigationControllerInstance)
        self.titleView.setButtonAction(
            backButtonAction: {
                
            }, connectionButtonAction: {
                
            }, menuButtonAction: {
                
            }
        )
        
        [ self.view, checkBoxContainer ].forEach { view in
            view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler)))
        }
    }
    
    func setBinding() {
        
    }
    
    @objc func tapGestureHandler(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.view {
        case view:
            view.endEditing(true)
        case self.checkBoxContainer:
            // TODO: vm에 탭 됐다고 전달 -> vm 에서 관련 변수 수정 -> observe로 확인 후 변경(아래 코드는 이동해야함)
            self.checkBoxImageView.image = UIImage(systemName: "checkmark.square.fill")
        default: return
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

// MARK: -
extension TerminalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: -
extension TerminalViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
