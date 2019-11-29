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
        
        var request: DataRequest {
            switch self {
            case .playerSummaries(let id):
                return ("ISteamUser/GetPlayerSummaries/v0002", ["steamids": "\(id)"]) >>> constructRequest
            case .friendsList(let id):
                return ("ISteamUser/GetFriendList/v0001", ["steamid": "\(id)", "relationship": "friend"]) >>> constructRequest
            case .playerOwnedGames(let id):
                return ("IPlayerService/GetOwnedGames/v0001", ["steamid": "\(id)", "include_appinfo": true]) >>> constructRequest
            case .playerGameAchievements(let steamID, let gameID):
                return ("ISteamUserStats/GetPlayerAchievements/v0001", ["steamid": "\(steamID)", "appid": "\(gameID)"]) >>> constructRequest
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
