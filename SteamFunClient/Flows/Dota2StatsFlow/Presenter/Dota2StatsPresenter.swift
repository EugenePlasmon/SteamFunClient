//
//  Dota2StatsPresenter.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2StatsPresenter {
    
    weak var viewInput: (UIViewController & Dota2StatsViewInput)?
    
    let steamUser: SteamUser
    let matches: [MatchDetails]
    
    init(steamUser: SteamUser, matches: [MatchDetails]) {
        self.steamUser = steamUser
        self.matches = matches
    }
}

extension Dota2StatsPresenter: Dota2StatsViewOutput {
    
    func viewDidLoad() {
        
        // 1 navbar
        viewInput?.addNavbar(imageUrl: steamUser.avatarLinks.full, title: steamUser.personName)
        
        // 2 plot
        let plotDataBuilder = MatchesPlotDataBuilder(steamUser: steamUser, matches: matches)
        let calculatedPlotModel = plotDataBuilder.calculate()
        let plot = Plot(model: calculatedPlotModel)
        viewInput?.addPlot(plot)
        
        // 3 topHeroes
        let topHeroesViewController = Dota2StatsTopHeroesViewController(steamUser: steamUser, matches: matches)
        viewInput?.addTopHeroesBlock(with: topHeroesViewController)
    }
}
