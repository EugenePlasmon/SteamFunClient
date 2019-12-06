//
//  TabbarConfigurator.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class TabbarConfigurator {
    
    let steamID: SteamID
    
    init(steamID: SteamID) {
        self.steamID = steamID
    }
    
    func createTabbar() -> UITabBarController {
        let tabBarController = TabbarViewController()
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
    
    private var viewControllers: [UIViewController] {
        [profileViewController, recentActivityViewController]
    }
    
    private var profileViewController: UIViewController {
        return ProfileModuleBuilder.build(steamID: steamID)
            >>> { InteractionDependableNavigationController(rootViewController: $0) }
            >>> {
                $0.tabBarItem = profileItem
                return $0
        }
    }
    
    private var recentActivityViewController: UIViewController {
        return RecentActivityModuleBuilder.build(steamID: steamID)
            >>> { InteractionDependableNavigationController(rootViewController: $0) }
            >>> {
                $0.tabBarItem = recentActivityItem
                return $0
        }
    }
    
    private var profileItem: UITabBarItem {
        UITabBarItem(title: "Профиль", image: UIImage(named: "tabbar_profile"), selectedImage: nil)
    }
    
    private var recentActivityItem: UITabBarItem {
        UITabBarItem(title: "Недавняя активность", image: UIImage(named: "tabbar_recentactivity"), selectedImage: nil)
    }
}
