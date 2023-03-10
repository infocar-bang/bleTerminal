//
//  SettingTableViewCell.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/10.
//

import UIKit

class SettingTableViewSwitchCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
        prepareForReuse()
    }

    func initView() {
        self.settingSwitch.addTarget(self, action: #selector(onSwitchValueChanged), for: .valueChanged)
    }
    
    func set(title: String, description: String, isOn: Bool) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        self.settingSwitch.isOn = isOn
    }
    
    @objc func onSwitchValueChanged(_ sender: UISwitch) {
        switch sender {
        case settingSwitch:
            // TODO: 변경 값 전달
            return
        default: return
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.descriptionLabel.text = ""
        self.settingSwitch.isOn = false
    }
}
