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
        fetchAuthorizedSteamID()
        startFetchMatchDetailsIfNeeded()
        fetchDota2Heroes { [weak self] in
            self?.initialCoordinator.startInitialFlow()
        }
    }
    
    private func fetchAuthorizedSteamID() {
        do {
            try Steam.SteamIDCaretaker.fetch()
        } catch {
            log(error)
        }
    }
    
    private func startFetchMatchDetailsIfNeeded() {
        guard let steamID = Steam.SteamIDCaretaker.steamID else {
            return
        }
        ServiceLocator.shared.matchesRequestManager(for: steamID).getUserMatches()
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
}
