//
//  GameSchema.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 05.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct GameSchema: Codable {
    
    let gameName: String
    let gameVersion: String?
    let availableGameStats: AvailableGameStats
    
    struct AvailableGameStats: Codable {
        let achievements: [GameAchievement]
    }
}
