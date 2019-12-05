//
//  UIViewController+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var defaultNavbarConfig: ExpandableNavbar.Config {
        return ExpandableNavbar.Config(backgroundBlurColor: FeatureColor.Navbar.background,
                                                     showBackButton: showNavbarBackButton,
                                                     scrollViewInsets: .init(top: 16.0, left: 0, bottom: 8.0, right: 0),
                                                     hasBlur: true)
    }
    
    var showNavbarBackButton: Bool {
        return self.navigationController >>- { $0.viewControllers.count > 1 } ?? false
    }
}
