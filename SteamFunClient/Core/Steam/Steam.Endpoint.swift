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
        
        case playerOwnedGames(id: SteamID)
        
        private var baseUrl: URL { URL(string: "http://api.steampowered.com")! }
        
        var request: DataRequest {
            switch self {
            case .playerSummaries(let id):
                let url = baseUrl.appendingPathComponent("ISteamUser/GetPlayerSummaries/v0002")
                let parameters = ["steamids": "\(id)", "key": Steam.apiKey]
                return AF.request(url, parameters: parameters)
            case .playerOwnedGames(let id):
                let url = baseUrl.appendingPathComponent("IPlayerService/GetOwnedGames/v0001")
                let parameters: [String: Any] = ["steamid": "\(id)", "include_appinfo": true, "key": Steam.apiKey]
                return AF.request(url, parameters: parameters)
            }
        }
    }
}
