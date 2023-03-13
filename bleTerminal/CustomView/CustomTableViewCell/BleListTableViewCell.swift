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
    
    func set(peer: PeripheralDevice) {
        self.rssiLabel.text = peer.rssi
        self.nameLabel.text = peer.name
        self.uuidLabel.text = peer.uuid
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.rssiLabel.text = ""
        self.nameLabel.text = ""
        self.uuidLabel.text = ""
    }
}
