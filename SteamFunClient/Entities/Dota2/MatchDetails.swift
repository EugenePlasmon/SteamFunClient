//
//  MatchDetails.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 29.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct MatchDetails {
    
    typealias Seconds = Int
    
    let id: Int
    let winner: DotaTeam
    let players: [Player]
    let duration: Seconds
    let preGameDuration: Seconds
    let start: Date
    let firstBloodTime: Seconds
    let humanPlayersCount: Int
    let kills: [DotaTeam: Int]
}

extension MatchDetails {
    
    struct Player {
        
        let accountID: Int?
        let slot: Int
        let heroID: Int
        let kills: Int
        let deaths: Int
        let assists: Int
        let leaverStatus: Int?
        let lastHits: Int
        let denies: Int
        let goldPerMin: Int
        let xpPerMin: Int
        let level: Int
        let playerName: String?
    }
}


extension MatchDetails: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "match_id"
        case radiantWin = "radiant_win"
        case players
        case duration
        case preGameDuration = "pre_game_duration"
        case start = "start_time"
        case firstBloodTime = "first_blood_time"
        case humanPlayersCount = "human_players"
        case radiantKills = "radiant_score"
        case direKills = "dire_score"
        // TODO:
        //game_mode: 22,
        //tower_status_radiant
        //tower_status_dire
        //barracks_status_radiant
        //barracks_status_dire
        //flags: 0,
        //engine: 1,
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let radiantWin = try container.decode(Bool.self, forKey: .radiantWin)
        self.id = try container.decode(Int.self, forKey: .id)
        self.winner = radiantWin ? .radiant : .dire
        self.players = try container.decode([Player].self, forKey: .players)
        self.duration = try container.decode(Seconds.self, forKey: .duration)
        self.preGameDuration = try container.decode(Seconds.self, forKey: .preGameDuration)
        let startTimestamp = try container.decode(Int.self, forKey: .start)
        self.start = Date(timeIntervalSince1970: TimeInterval(startTimestamp))
        self.firstBloodTime = try container.decode(Seconds.self, forKey: .firstBloodTime)
        self.humanPlayersCount = try container.decode(Int.self, forKey: .humanPlayersCount)
        let radiantKills = try container.decode(Int.self, forKey: .radiantKills)
        let direKills = try container.decode(Int.self, forKey: .direKills)
        self.kills = [.radiant: radiantKills, .dire: direKills]
    }
}

extension MatchDetails.Player: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case accountID = "account_id"
        case slot = "player_slot"
        case heroID = "hero_id"
        case kills
        case deaths
        case assists
        case leaverStatus = "leaver_status"
        case lastHits = "last_hits"
        case denies
        case goldPerMin = "gold_per_min"
        case xpPerMin = "xp_per_min"
        case level
        case playerName = "persona"
        // TODO:
        //item_0: 231,
        //item_1: 0,
        //item_2: 0,
        //item_3: 0,
        //item_4: 0,
        //item_5: 100,
        //backpack_0: 0,
        //backpack_1: 0,
        //backpack_2: 0,
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accountID = try? container.decode(Int.self, forKey: .accountID)
        self.slot = try container.decode(Int.self, forKey: .slot)
        self.heroID = try container.decode(Int.self, forKey: .heroID)
        self.kills = try container.decode(Int.self, forKey: .kills)
        self.deaths = try container.decode(Int.self, forKey: .deaths)
        self.assists = try container.decode(Int.self, forKey: .assists)
        self.leaverStatus = try? container.decode(Int.self, forKey: .leaverStatus)
        self.lastHits = try container.decode(Int.self, forKey: .lastHits)
        self.denies = try container.decode(Int.self, forKey: .denies)
        self.goldPerMin = try container.decode(Int.self, forKey: .goldPerMin)
        self.xpPerMin = try container.decode(Int.self, forKey: .xpPerMin)
        self.level = try container.decode(Int.self, forKey: .level)
        self.playerName = try? container.decode(String.self, forKey: .playerName)
    }
}
