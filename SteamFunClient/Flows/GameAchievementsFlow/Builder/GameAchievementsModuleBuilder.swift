//
//  GameAchievementsModuleBuilder.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 05.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class GameAchievementsModuleBuilder {
    
    static func build(game: Game, steamID: SteamID) -> GameAchievementsViewController {
        let presenter = GameAchievementsPresenter(game: game, steamID: steamID)
        let viewController = GameAchievementsViewController(output: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
