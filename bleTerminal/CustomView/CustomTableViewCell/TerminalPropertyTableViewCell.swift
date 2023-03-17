//
//  TerminalPropertyTableViewCell.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/16.
//

import UIKit

class TerminalPropertyTableViewCell: UITableViewCell {
    @IBOutlet weak var characteristcLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
        prepareForReuse()
    }
    
    func initView() {
        
    }
    
    func set(serviceProperty: ServiceProperty) {
        self.characteristcLabel.text = "Characteristic: \(serviceProperty.role)"
        self.uuidLabel.text = serviceProperty.uuid
        if serviceProperty.isSelected {
            self.checkBoxImageView.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            self.checkBoxImageView.image = UIImage(systemName: "square")
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.characteristcLabel.text = ""
        self.uuidLabel.text = ""
        self.checkBoxImageView.image = UIImage(systemName: "square")
    }
}
