//
//  RoundedView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 07.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

open class RoundedView: UIView {
    
    var rounded: Bool = true {
           didSet {
               layoutSubviews()
           }
       }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = rounded ? min(self.frame.width, self.frame.height) / 2.0 : 0.0
    }
}

open class RoundedImageView: UIImageView {
    
    var rounded: Bool = true {
        didSet {
            layoutSubviews()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = rounded ? min(self.frame.width, self.frame.height) / 2.0 : 0.0
    }
}
