//
//  TerminalViewController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/10.
//

import UIKit

class TerminalViewController: UIViewController {
    @IBOutlet weak var titleView: TitleView!
    
    @IBOutlet weak var movableContainer: UIView!
    @IBOutlet weak var macroContainer: UIView!
    
    @IBOutlet weak var checkBoxContainer: UIStackView!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            self.movableContainer.frame.origin.y -= (keyboardFrame.height - macroContainer.frame.height)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            self.movableContainer.frame.origin.y += (keyboardFrame.height - macroContainer.frame.height)
        }
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
