//
//  Steam+Endpoints.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation
import Alamofire

extension Steam {
    
    enum Endpoint {
        
        case playerSummaries(id: SteamID)
        
        case friendsList(id: SteamID)
        
        case playerOwnedGames(id: SteamID)
        
        case playerGameAchievements(steamID: SteamID, gameID: GameID)
        
        case recentlyPlayedGames(steamID: SteamID)
        
        case dota2MatchesHistory(steamID: SteamID32, heroID: Int?, startAtMatchID: Int?, batchSize: Int?)
        
        case dota2MatchDetails(matchID: Int)
        
        var request: DataRequest {
            switch self {
            case .playerSummaries(let id):
                return ("ISteamUser/GetPlayerSummaries/v0002",
                        ["steamids": "\(id)"])
                    >>> constructRequest
            case .friendsList(let id):
                return ("ISteamUser/GetFriendList/v0001",
                        ["steamid": "\(id)", "relationship": "friend"])
                    >>> constructRequest
            case .playerOwnedGames(let id):
                return ("IPlayerService/GetOwnedGames/v0001",
                        ["steamid": "\(id)", "include_appinfo": 1])
                    >>> constructRequest
            case .playerGameAchievements(let steamID, let gameID):
                return ("ISteamUserStats/GetPlayerAchievements/v0001",
                        ["steamid": "\(steamID)", "appid": "\(gameID)"])
                    >>> constructRequest
            case .recentlyPlayedGames(let steamID):
                return ("IPlayerService/GetRecentlyPlayedGames/v0001",
                        ["steamid": steamID])
                    >>> constructRequest
            case .dota2MatchesHistory(let steamID, let heroID, let startAtMatchID, let batchSize):
                var parameters: [String: Any] = ["account_id": steamID]
                heroID >>- { parameters["hero_id"] = $0 }
                startAtMatchID >>- { parameters["start_at_match_id"] = $0 }
                batchSize >>- { parameters["matches_requested"] = $0 }
                return ("IDOTA2Match_570/GetMatchHistory/v1",
                        parameters)
                    >>> constructRequest
            case .dota2MatchDetails(let matchID):
                return ("IDOTA2Match_570/GetMatchDetails/v1",
                        ["match_id": matchID, "include_persona_names": 1])
                    >>> constructRequest
            }
        }
        
        // MARK: - Private
        
        private var baseUrl: URL { URL(string: "http://api.steampowered.com")! }
        
        private func constructRequest(method: String, parameters: [String: Any]) -> DataRequest {
            let url = baseUrl.appendingPathComponent(method)
            let parameters = ["key": Steam.apiKey].merging(parameters) { $1 }
            
            let curl = url.appendingPathComponent("?").absoluteString
                + parameters
                    .map { $0.key + "=" + "\($0.value)" }
                    .joined(separator: "&")
            log(.startNetworkRequest, curl)
            
            return AF.request(url, parameters: parameters)
        }
    }
}
