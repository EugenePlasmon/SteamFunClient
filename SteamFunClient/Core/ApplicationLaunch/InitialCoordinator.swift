//
//  InitialCoordinator.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 07.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class InitialCoordinator {
    
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func startInitialFlow() {
        // TODO: Debug
        if let debugSteamID = debugSteamID {
            self.startTabBarFlow(steamID: debugSteamID)
            return
        }
        
        if let steamID = Steam.SteamIDCaretaker.steamID {
            self.startTabBarFlow(steamID: steamID)
        } else {
            self.startSteamAuthFlow()
        }
    }
    
    // MARK: - Private
    
    private func startSteamAuthFlow() {
        let steamAuthViewController = SteamAuthModuleBuilder.build { result in
            result.onSuccess { [weak self] steamID in
                try? Steam.SteamIDCaretaker.store(steamID)
                self?.startTabBarFlow(steamID: steamID)
            }.onFailure {
                // TODO:
                log($0)
            }
        }
        let navigationController = UINavigationController(rootViewController: steamAuthViewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }
    
    private var tabbarConfigurator: TabbarConfigurator?
    
    private func startTabBarFlow(steamID: SteamID) {
        tabbarConfigurator = TabbarConfigurator(steamID: steamID, profileOutput: self)
        self.window?.rootViewController = tabbarConfigurator?.createTabbar()
        self.window?.makeKeyAndVisible()
    }
}

// MARK: - ProfileModuleOutput

extension InitialCoordinator: ProfileModuleOutput {
    
    func profileDidLogout() {
        try? Steam.SteamIDCaretaker.clear()
        startInitialFlow()
    }
}