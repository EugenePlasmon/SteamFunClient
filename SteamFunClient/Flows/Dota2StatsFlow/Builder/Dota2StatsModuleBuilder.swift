//
//  Dota2StatsModuleBuilder.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2StatsModuleBuilder {
    
    static func build(steamUser: SteamUser, matches: [MatchDetails]) -> Dota2StatsViewController {
        let presenter = Dota2StatsPresenter(steamUser: steamUser, matches: matches)
        let viewController = Dota2StatsViewController(output: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
