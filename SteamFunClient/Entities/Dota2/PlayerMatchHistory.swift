//
//  PlayerMatchHistory.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 29.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct PlayerMatchHistory {
    
    struct Match {
        
        struct Player {
            
            let accountID: Int?
            let playerSlot: Int
            let heroID: Int
        }
        
        let id: Int
        let start: Date?
        let players: [Player]
    }
    
    let totalResultsCount: Int
    let remainingResultsCount: Int
    let matches: [Match]
}

// MARK: - Codable

extension PlayerMatchHistory.Match: Codable {
    
    enum CodingKeys: String, CodingKey {
        case id = "match_id"
        case start = "start_time"
        case players
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.start = (try? container.decode(Int.self, forKey: .start))
            >>- { Date(timeIntervalSince1970: Double($0)) }
        self.players = try container.decode([Player].self, forKey: .players)
    }
}

extension PlayerMatchHistory.Match.Player: Codable {
    
    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case playerSlot = "player_slot"
        case heroID = "hero_id"
    }
}

extension PlayerMatchHistory: Codable {
    
    enum CodingKeys: String, CodingKey {
        case totalResultsCount = "total_results"
        case remainingResultsCount = "results_remaining"
        case matches
    }
}
