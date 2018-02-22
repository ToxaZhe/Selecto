//
//  ViewWithBorder.swift
//  Selecto
//
//  Created by user on 2/22/18.
//  Copyright © 2018 Toxa. All rights reserved.
//

import UIKit

class ViewWithBorder: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    func initialize() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1).cgColor
    }
}
