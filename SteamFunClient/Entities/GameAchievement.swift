//
//  GameAchievement.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 05.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct GameAchievement {
    
    let apiName: String
    let displayName: String
    let description: String?
    let hidden: Bool
    let iconUrl: String?
    let iconGrayUrl: String?
}

// MARK: - Codable

extension GameAchievement: Codable {
    
    enum CodingKeys: String, CodingKey {
        case apiName = "name"
        case displayName
        case description
        case hidden
        case iconUrl = "icon"
        case iconGrayUrl = "icongray"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.apiName = try container.decode(String.self, forKey: .apiName)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.description = try? container.decode(String.self, forKey: .description)
        let hidden = (try? container.decode(Int.self, forKey: .hidden)) ?? 0
        self.hidden = hidden == 1
        self.iconUrl = try? container.decode(String.self, forKey: .iconUrl)
        self.iconGrayUrl = try? container.decode(String.self, forKey: .iconGrayUrl)
    }
}
