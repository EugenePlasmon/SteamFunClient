//
//  UIScrollView+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 27.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public extension UIScrollView {
    
    /// Проскроллить вью к началу (верху).
    ///
    /// - Parameter animated: С анимацией скролла или без.
    func scrollToBegin(animated: Bool = false) {
        self.setContentOffset(CGPoint(x: 0.0, y: -self.contentInset.top), animated: animated)
    }
}
