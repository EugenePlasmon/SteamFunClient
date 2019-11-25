//
//  AppLauncher.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class AppLauncher {
    
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        do {
            try Steam.SteamIDCaretaker.fetch()
        } catch {
            // TODO:
        }
        if let steamID = Steam.SteamIDCaretaker.steamID {
            startTabBarFlow(steamID: steamID)
        } else {
            startSteamAuthFlow()
        }
    }
    
    private func startSteamAuthFlow() {
        let steamAuthViewController = SteamAuthModuleBuilder.build { result in
            result.onSuccess { [weak self] steamID in
                try? Steam.SteamIDCaretaker.store(steamID)
                self?.startTabBarFlow(steamID: steamID)
            }.onFailure {
                // TODO:
                print($0)
            }
        }
        let navigationController = UINavigationController(rootViewController: steamAuthViewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    private func startTabBarFlow(steamID: SteamID) {
        let profileViewController = ProfileModuleBuilder.build(steamID: steamID)
        let profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        // TODO:
        profileNavigationController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "tabbar_profile"), selectedImage: nil)
        
        let tabBarController = TabbarViewController()
        tabBarController.viewControllers = [profileNavigationController]
        
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }
}
