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
    
    let id: MatchID
    let gameMode: GameMode
    let winner: Dota2Team
    let players: [Player]
    let duration: Seconds
    let preGameDuration: Seconds
    let start: Date
    let firstBloodTime: Seconds
    let humanPlayersCount: Int
    let kills: [Dota2Team: Int]
}

extension MatchDetails {
    
    struct Player {
        
        enum Slot: Int {
            case radiant1 = 0
            case radiant2 = 1
            case radiant3 = 2
            case radiant4 = 3
            case radiant5 = 4
            case dire1 = 128
            case dire2 = 129
            case dire3 = 130
            case dire4 = 131
            case dire5 = 132
            
            var team: Dota2Team {
                switch self {
                case .radiant1, .radiant2, .radiant3, .radiant4, .radiant5:
                    return .radiant
                case .dire1, .dire2, .dire3, .dire4, .dire5:
                    return .dire
                }
            }
        }
        
        let accountID: Int64?
        let slot: Slot
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

extension MatchDetails {
    
    enum GameMode: Int, Codable {
        case none = 0
        case allPick = 1
        case captainsMode = 2
        case randomDraft = 3
        case singleDraft = 4
        case allRandom = 5
        case intro = 6
        case diretide = 7
        case reverseCaptainsMode = 8
        case theGreeviling = 9
        case tutorial = 10
        case midOnly = 11
        case leastPlayed = 12
        case newPlayerPool = 13
        case compendiumMatchmaking = 14
        case coopVsBots = 15
        case captainsDraft = 16
        case abilityDraft = 18
        case allRandomDeathmatch = 20
        case midOnly1v1 = 21
        case rankedMatchmaking = 22
    }
}

// MARK: - Helper Methods

extension MatchDetails {
    
    func teamOfUser(steamID: SteamID) -> Dota2Team? {
        guard let player = players.first(where: { $0.accountID == Int64(steamID.to32) }) else {
            return nil
        }
        return player.slot.team
    }
    
    func heroIDOfUser(steamID: SteamID) -> Int? {
        guard let player = players.first(where: { $0.accountID == Int64(steamID.to32) }) else {
            return nil
        }
        return player.heroID
    }
    
    func isUserWinner(steamID: SteamID) -> Bool? {
        guard let player = players.first(where: { $0.accountID == Int64(steamID.to32) }) else {
            return nil
        }
        return winner == player.slot.team
    }
}

// MARK: - Decodable

extension MatchDetails: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id = "match_id"
        case gameMode = "game_mode"
        case radiantWin = "radiant_win"
        case players
        case duration
        case preGameDuration = "pre_game_duration"
        case start = "start_time"
        case firstBloodTime = "first_blood_time"
        case humanPlayersCount = "human_players"
        case radiantKills = "radiant_score"
        case direKills = "dire_score"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let radiantWin = try container.decode(Bool.self, forKey: .radiantWin)
        self.id = try container.decode(MatchID.self, forKey: .id)
        do {
            let gameMode = try container.decode(GameMode.self, forKey: .gameMode)
            self.gameMode = gameMode
        } catch {
            throw Steam.Error.unknownGameMode
        }
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
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.accountID = try? container.decode(Int64.self, forKey: .accountID)
        self.slot = try container.decode(Slot.self, forKey: .slot)
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

extension MatchDetails.Player.Slot: Decodable { }
