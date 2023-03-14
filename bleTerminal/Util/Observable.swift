//
//  Observable.swift
//  bleTerminal
//
//  Created by infocar on 2023/03/14.
//

import Foundation

class Observable<T> {
    var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: (@escaping (T) -> Void)) {
        self.listener = listener
    }
}
