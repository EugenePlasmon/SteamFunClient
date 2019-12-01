//
//  RecentActivityPresenter.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class RecentActivityPresenter {
    
    weak var viewInput: RecentActivityViewInput?
    
    let steamID: SteamID
    
    init(steamID: SteamID) {
        self.steamID = steamID
    }
}

extension RecentActivityPresenter: RecentActivityViewOutput {
    
    func viewDidLoad() {
        self.viewInput?.showLoader()
        Steam.getRecentlyPlayedGames(steamID: steamID) { [weak self] result in
            result.onSuccess {
                self?.viewInput?.showData($0)
            }.onFailure {
                // TODO:
                print($0)
            }
        }
    }
}
