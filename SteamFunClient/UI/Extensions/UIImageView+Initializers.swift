//
//  UIImageView+Initializers.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension UIImageView {
    
    convenience init(contentMode: UIView.ContentMode, clipsToBounds: Bool = false) {
        self.init(frame: .zero)
        self.contentMode = contentMode
        self.clipsToBounds = clipsToBounds
    }
}
