//
//  SettingPopupViewController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/10.
//

import UIKit

class SettingPopupViewController: UIViewController {
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initTableViewCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initView() {
        self.popupView.layer.cornerRadius = 15
        self.popupView.layer.masksToBounds = true
        
        [ cancelButton ].forEach { button in
            button?.addTarget(self, action: #selector(buttonActionHandler), for: .touchUpInside)
        }
    }
    
    func initTableViewCell() {
        let cellNib = UINib(nibName: "SettingPopupItemTableViewCell", bundle: Bundle(for: self.classForCoder))
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell")
    }
    
    @objc func buttonActionHandler(_ sender: UIButton) {
        switch sender {
        case cancelButton: self.dismiss(animated: false)
        default: return
        }
    }
}

extension SettingPopupViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingPopupItemTableViewCell else { return UITableViewCell() }
            cell.set(title: "14sp")
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingPopupItemTableViewCell else { return UITableViewCell() }
            cell.set(title: "16sp", isSelected: true)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension SettingPopupViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: false) {
            // TODO: 선택된 아이템 정보 전달 -> settingView의 ViewModel에서 앱 전체 적용 및 저장(UserDefault)
        }
    }
}
