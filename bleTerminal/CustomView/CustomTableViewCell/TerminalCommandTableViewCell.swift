//
//  TerminalCommandTableViewCell.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/13.
//

import UIKit

class TerminalCommandTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareForReuse()
    }
    
    func initView() {
        
    }
    
    func set(command: String) {
        self.label.text = "ASCII: " + command
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.label.text = ""
    }
}
