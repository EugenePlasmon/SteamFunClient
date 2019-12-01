//
//  AppLauncher.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import RealmSwift

final class AppLauncher {
    
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        if dropRealmDBOnStart {
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
        }
        
        fetchSteamID()
        fetchDota2Heroes { [weak self] in
            self?.startInitialFlow()
        }
    }
    
    private func fetchDota2Heroes(then completion: @escaping () -> Void) {
        switch Dota2HeroResourceManager.shared.state {
        case .error, .finished:
            completion()
            return
        case .loading:
            Dota2HeroResourceManager.shared.onLoad = { _ in
                completion()
            }
        }
    }
    
    private func fetchSteamID() {
        do {
            try Steam.SteamIDCaretaker.fetch()
        } catch {
            // TODO:
        }
    }
    
    // MARK: - Start flow
    
    private func startInitialFlow() {
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
    
    private func startTabBarFlow(steamID: SteamID) {
        self.window?.rootViewController = TabbarConfigurator(steamID: steamID).createTabbar()
        self.window?.makeKeyAndVisible()
    }
}
