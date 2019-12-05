//
//  GameAchievementsViewInterface.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 05.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

struct GameAchievementsViewModel {
    
    typealias Percents = Double
    
    struct Header {
        let gameName: String
        let gameLogoUrl: String?
        let gameIconUrl: String?
        let playerProgress: Percents
    }
    
    struct Cell {
        let hidden: Bool
        let name: String
        let description: String?
        let globalPercentage: Percents
        let unlocked: Bool
        let unlockDate: Date?
        let imageUrl: String?
    }
    
    let header: Header
    let cells: [Cell]
}

protocol GameAchievementsViewInput: class {
    
    func showLoader()
    
    func showData(viewModel: GameAchievementsViewModel)
}

protocol GameAchievementsViewOutput: class {
    
    func viewDidLoad()
}
