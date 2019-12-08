//
//  Dota2ServicesLocator.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 08.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class Dota2ServicesLocator {
    
    static let shared = Dota2ServicesLocator()
    
    private var matchesRequestManagers: [SteamID: Dota2MatchesRequestManager] = [:]
    
    func matchesRequestManager(for steamID: SteamID) -> Dota2MatchesRequestManager {
        if let existing = matchesRequestManagers[steamID] {
            return existing
        }
        let new = Dota2MatchesRequestManager(steamID: steamID)
        self.matchesRequestManagers[steamID] = new
        return new
    }
}
