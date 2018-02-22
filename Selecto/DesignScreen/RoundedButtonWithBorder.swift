//
//  RoundedButtonWithBorder.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import UIKit

class RoundedButtonWithBorder: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    func initialize(){
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 10.0
        self.layer.borderColor = UIColor(red:55/255.0, green:181/255.0, blue:190/255.0, alpha: 1.0).cgColor
        self.clipsToBounds = true
    }
}
