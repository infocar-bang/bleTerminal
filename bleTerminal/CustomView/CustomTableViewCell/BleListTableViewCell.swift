//
//  BleListTableViewCell.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/08.
//

import UIKit

class BleListTableViewCell: UITableViewCell {
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
        prepareForReuse()
    }
    
    func initView() {
        self.rssiLabel.layer.cornerRadius = rssiLabel.frame.width / 2
        self.rssiLabel.layer.masksToBounds = true
    }
    
    func set() {
        self.rssiLabel.text = "-90"
        self.nameLabel.text = "Unnamed"
        self.uuidLabel.text = "AE9C1DB0-48F1-4914-9940-85FE7AEEA1A3"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.rssiLabel.text = ""
        self.nameLabel.text = ""
        self.uuidLabel.text = ""
    }
}
