//
//  UIView+Shadow.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension UIView {
    
    func applyShadow(_ shadow: Shadow) {
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOpacity = Float(shadow.opacity)
        layer.shadowOffset = CGSize(width: shadow.offsetX, height: shadow.offsetY)
        layer.shadowRadius = shadow.radius
    }
}
