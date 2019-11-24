//
//  Steam+PublicMethods.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation
import Alamofire

extension Steam {
    
    static func getProfileInfo(for steamID: SteamID, then completion: @escaping (Result<SteamUser, AFError>) -> Void) {
        Steam.Endpoint.playerSummaries(id: steamID).request.responseDecodable(of: Response<PlayerSummariesResponse>.self) { dataResponse in
            dataResponse.result
                .map { $0.response.players.first! }
                >>> completion
        }
    }
    
    static func getOwnedGames(for steamID: SteamID, then completion: @escaping (Result<[Game], AFError>) -> Void) {
        Steam.Endpoint.playerOwnedGames(id: steamID).request.responseDecodable(of: Response<PlayerOwnedGamesResponse>.self) { dataResponse in
            dataResponse.result
                .map { $0.response.games }
                >>> completion
        }
    }
}

private struct Response<T: Codable>: Codable {
    let response: T
}

private struct PlayerSummariesResponse: Codable {
    let players: [SteamUser]
}

private struct PlayerOwnedGamesResponse: Codable {
    let games: [Game]
}
