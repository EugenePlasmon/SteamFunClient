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
    
    static func getFriends(for steamID: SteamID, then completion: @escaping (Result<[Friend], AFError>) -> Void) {
        Steam.Endpoint.friendsList(id: steamID).request.responseDecodable(of: FriendsList.self) { dataResponse in
            dataResponse.result
                .map { $0.friendsList.friends }
                >>> completion
        }
    }
    
    static func getOwnedGames(for steamID: SteamID, then completion: @escaping (Result<[OwnedGame], AFError>) -> Void) {
        Steam.Endpoint.playerOwnedGames(id: steamID).request.responseDecodable(of: Response<PlayerOwnedGamesResponse>.self) { dataResponse in
            dataResponse.result
                .map { $0.response.games }
                >>> completion
        }
    }
    
    static func getPlayerGameAchievements(steamID: SteamID, gameID: GameID, then completion: @escaping (Result<PlayerGameAchievements, AFError>) -> Void) {
        Steam.Endpoint.playerGameAchievements(steamID: steamID, gameID: gameID).request.responseDecodable(of: PlayerStats<PlayerGameAchievements>.self) { dataResponse in
            dataResponse.result
                .map { $0.playerStats }
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
    let games: [OwnedGame]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.games = (try? container.decode([OwnedGame].self, forKey: .games)) ?? []
    }
}

private struct FriendsList: Codable {
    struct Friends: Codable {
        let friends: [Friend]
    }
    let friendsList: Friends
    enum CodingKeys: String, CodingKey {
        case friendsList = "friendslist"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.friendsList = (try? container.decode(Friends.self, forKey: .friendsList)) ?? Friends(friends: [])
    }
}

private struct PlayerStats<T: Codable>: Codable {
    let playerStats: T
}
