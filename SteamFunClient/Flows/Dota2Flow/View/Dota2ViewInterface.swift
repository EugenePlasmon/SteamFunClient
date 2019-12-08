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
    
    struct Navbar {
        let title: String
        let iconUrl: String?
    }
    
    let shortStats: ShortStats
    let navbar: Navbar
    let matches: [Match]
}

protocol Dota2ViewInput: class {
    
    func showLoader()
    
    func showData(viewModel: Dota2ViewModel)
    
    func showError(message: String, navbarModel: Dota2ViewModel.Navbar)
}

protocol Dota2ViewOutput: class {
    
    func viewDidLoad()
    
    func viewDidTapMoreStats()
}
