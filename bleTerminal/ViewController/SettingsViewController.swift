//
//  SettingsViewController.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/09.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var titleView: TitleView!
    @IBOutlet weak var tableView: UITableView!
    
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
        self.titleView.initView(from: self.nameString)
        
        self.titleView.onDidTapBackButton = { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func initTableViewCell() {
        let cellNib = UINib(nibName: "SettingTableViewCell", bundle: Bundle(for: self.classForCoder))
        self.tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        let switchCellNib = UINib(nibName: "SettingTableViewSwitchCell", bundle: Bundle(for: self.classForCoder))
        self.tableView.register(switchCellNib, forCellReuseIdentifier: "switchCell")
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SettingTableViewCell else { return UITableViewCell() }
            cell.set(title: "Font Size", value: "28sp")
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as? SettingTableViewSwitchCell else { return UITableViewCell() }
            cell.set(title: "Timestamp enable", description: "Show date & time on received message", isOn: true)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let popupVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingPopupViewController") as? SettingPopupViewController else {
                return
            }
            popupVC.modalPresentationStyle = .overFullScreen
            self.present(popupVC, animated: false)
        default: return
        }
    }
}
