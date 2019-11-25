//
//  TabbarViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 27.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class TabbarViewController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        tabBar.barTintColor = FeatureColor.Tabbar.background
        tabBar.tintColor = FeatureColor.Tabbar.item
        tabBar.unselectedItemTintColor = FeatureColor.Tabbar.unselectedItem
    }
}
