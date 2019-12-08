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
    
    private lazy var initialCoordinator = InitialCoordinator(window: window)
    
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
            self?.initialCoordinator.startInitialFlow()
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
            log(error)
        }
    }
}
