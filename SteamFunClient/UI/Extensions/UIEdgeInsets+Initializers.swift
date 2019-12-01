//
//  UIEdgeInsets+Initializers.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    
    init(top: CGFloat = 0.0, left: CGFloat = 0.0, bottom: CGFloat = 0.0, right: CGFloat = 0.0) {
        self.init()
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
    
    static func top(_ top: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
    }
    
    static func left(_ left: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
    }
    
    static func bottom(_ bottom: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: bottom, right: 0)
    }
    
    static func right(_ right: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: right)
    }
}
