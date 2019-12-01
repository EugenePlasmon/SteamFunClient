//
//  UIView+Initializers.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension UIView {
    
    convenience init(color: UIColor) {
        self.init(frame: .zero)
        backgroundColor = color
    }
}
