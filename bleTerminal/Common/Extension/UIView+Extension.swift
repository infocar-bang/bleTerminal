//
//  UIView+Extension.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/10.
//

import UIKit

extension UIView {
    static var nibName: String {
        get {
            return String(describing: type(of: self))
        }
    }
    
    func loadNib() {
        subviews.forEach({ $0.removeFromSuperview() })
        let nibName = String(describing: type(of: self))
        
        guard Bundle(for: self.classForCoder).path(forResource: nibName, ofType: "nib") != nil else { return }
        guard let view = Bundle(for: self.classForCoder).loadNibNamed(nibName, owner: self, options: nil)?.first(where: { $0 is UIView }) as? UIView else { return }
        
        view.frame = bounds
        addSubview(view)
        backgroundColor = .clear
    }
}
