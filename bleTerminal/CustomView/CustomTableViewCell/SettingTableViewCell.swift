//
//  SettingTableViewCell.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/10.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
        prepareForReuse()
    }
    
    func initView() {
        
    }
    
    func set(title: String, value: String) {
        self.titleLabel.text = title
        self.valueLabel.text = value
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.valueLabel.text = ""
    }
}
