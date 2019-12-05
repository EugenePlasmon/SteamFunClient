//
//  Dota2ViewInterface.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct Dota2ViewModel {
    
    struct ShortStats {
        let averageWinrate: Double
        let averageMatchDuration: Game.Minutes
        let favoriteTeam: Dota2Team
        let favoriteHeroID: Int?
    }
    
    struct Match {
        let hero: Dota2Hero
        let team: Dota2Team
        let isWin: Bool
        let date: Date
    }
    
    let navbarTitle: String
    let navbarIconUrl: String?
    let shortStats: ShortStats
    let matches: [Match]
}

protocol Dota2ViewInput: class {
    
    func showLoader()
    
    func showData(viewModel: Dota2ViewModel)
}

protocol Dota2ViewOutput: class {
    
    func viewDidLoad()
}
