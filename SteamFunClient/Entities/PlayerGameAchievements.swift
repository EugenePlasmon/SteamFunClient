//
//  PlayerGameAchievements.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 27.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct PlayerGameAchievements {
    
    struct Achievement {
        
        let apiName: String
        let achieved: Bool
        let unlockDate: Date?
    }
    
    let steamID: SteamID
    let gameName: String
    let achievements: [Achievement]
}

// MARK: - Codable

extension PlayerGameAchievements: Codable {
    
    enum CodingKeys: String, CodingKey {
        case steamID
        case gameName
        case achievements
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .steamID)
        if let steamID = SteamID(idString) {
            self.steamID = steamID
        } else {
            throw SteamError.parsingError
        }
        self.gameName = try container.decode(String.self, forKey: .gameName)
        self.achievements = try container.decode([Achievement].self, forKey: .achievements)
    }
}

extension PlayerGameAchievements.Achievement: Codable {
    
    enum CodingKeys: String, CodingKey {
        case apiName = "apiname"
        case achieved
        case unlockDate = "unlocktime"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.apiName = try container.decode(String.self, forKey: .apiName)
        self.achieved = (try? container.decode(Bool.self, forKey: .achieved)) ?? false
        if let unlockTimestamp = try? container.decode(Double.self, forKey: .unlockDate), unlockTimestamp != 0 {
            self.unlockDate = Date(timeIntervalSince1970: unlockTimestamp)
        } else {
            self.unlockDate = nil
        }
    }
}
