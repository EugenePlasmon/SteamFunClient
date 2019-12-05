//
//  GlobalAchievementPercentages.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 05.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct GlobalAchievementPercentages: Codable {
    
    struct Achievement: Codable {
        let name: String
        let percent: Double
    }
    
    let achievements: [Achievement]
}
