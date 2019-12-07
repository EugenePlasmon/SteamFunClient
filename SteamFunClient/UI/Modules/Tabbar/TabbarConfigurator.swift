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
    private weak var profileOutput: ProfileModuleOutput?
    
    init(steamID: SteamID, profileOutput: ProfileModuleOutput?) {
        self.steamID = steamID
        self.profileOutput = profileOutput
    }
    
    func createTabbar() -> UITabBarController {
        let tabBarController = TabbarViewController()
        tabBarController.viewControllers = createModules()
        return tabBarController
    }
    
    private func createModules() -> [UIViewController] {
        return [createProfileModule(), createRecentActivityModule()]
    }
    
    private func createProfileModule() -> UIViewController {
        return ProfileModuleBuilder.build(steamID: steamID, output: profileOutput)
            >>> { InteractionDependableNavigationController(rootViewController: $0) }
            >>> {
                $0.tabBarItem = profileItem
                return $0
        }
    }
    
    private func createRecentActivityModule() -> UIViewController {
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
