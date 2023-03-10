//
//  SettingPopupItemTableViewCell.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/10.
//

import UIKit

class SettingPopupItemTableViewCell: UITableViewCell {
    @IBOutlet weak var selectorImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
        prepareForReuse()
    }

    func initView() {
        
    }
    
    func set(title: String, isSelected: Bool = false) {
        self.titleLabel.text = title
        if isSelected {
            self.selectorImageView.image = UIImage(systemName: "circle.inset.filled")
            self.selectorImageView.tintColor = .systemBlue
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.selectorImageView.image = UIImage(systemName: "circle")
        self.selectorImageView.tintColor = .label
        self.titleLabel.text = ""
    }
}
