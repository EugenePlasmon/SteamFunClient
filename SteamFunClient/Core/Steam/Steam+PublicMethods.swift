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
    
    static func getProfileInfo(for steamID: SteamID,
                               then completion: @escaping (Result<SteamUser, AFError>) -> Void) {
        
        Steam.Endpoint.playerSummaries(id: steamID).request.responseDecodable(of: Response<PlayerSummariesResponse>.self, decoder: decoder(keyPath: "response")) { dataResponse in
            dataResponse.result
                .map { $0.result.players.first! }
                >>> completion
        }
    }
    
    static func getFriends(for steamID: SteamID,
                           then completion: @escaping (Result<[Friend], AFError>) -> Void) {
        
        Steam.Endpoint.friendsList(id: steamID).request.responseDecodable(of: FriendsList.self) { dataResponse in
            dataResponse.result
                .map { $0.friendsList.friends }
                >>> completion
        }
    }
    
    static func getOwnedGames(for steamID: SteamID,
                              then completion: @escaping (Result<[Game], AFError>) -> Void) {
        
        Steam.Endpoint.playerOwnedGames(id: steamID).request.responseDecodable(of: Response<GamesResponse>.self, decoder: decoder(keyPath: "response")) { dataResponse in
            dataResponse.result
                .map { $0.result.games }
                >>> completion
        }
    }
    
    static func getPlayerGameAchievements(steamID: SteamID,
                                          gameID: GameID,
                                          then completion: @escaping (Result<PlayerGameAchievements, AFError>) -> Void) {
        
        Steam.Endpoint.playerGameAchievements(steamID: steamID, gameID: gameID).request.responseDecodable(of: Response<PlayerGameAchievements>.self, decoder: decoder(keyPath: "playerStats")) { dataResponse in
            dataResponse.result
                .map { $0.result }
                >>> completion
        }
    }
    
    static func getRecentlyPlayedGames(steamID: SteamID, then completion: @escaping (Result<[Game], AFError>) -> Void) {
        Steam.Endpoint.recentlyPlayedGames(steamID: steamID).request.responseDecodable(of: Response<GamesResponse>.self, decoder: decoder(keyPath: "response")) { dataResponse in
            dataResponse.result
                .map { $0.result.games }
                >>> completion
        }
    }
    
    static func dota2MatchesHistory(steamID: SteamID32,
                                    heroID: Int? = nil,
                                    startAtMatchID: Int? = nil,
                                    batchSize: Int? = nil,
                                    then completion: @escaping (Result<PlayerMatchesHistory, AFError>) -> Void) {
        
        Steam.Endpoint.dota2MatchesHistory(steamID: steamID,
                                           heroID: heroID,
                                           startAtMatchID: startAtMatchID,
                                           batchSize: batchSize)
            .request.responseDecodable(of: Response<PlayerMatchesHistory>.self, decoder: decoder(keyPath: "result")) { dataResponse in
                dataResponse.result
                    .map { $0.result }
                    >>> completion
        }
    }
    
    static func dota2MatchDetails(matchID: Int, then completion: @escaping (Result<MatchDetails, AFError>) -> Void) {
        Steam.Endpoint.dota2MatchDetails(matchID: matchID)
            .request.responseDecodable(of: Response<MatchDetails>.self, decoder: decoder(keyPath: "result")) { dataResponse in
                dataResponse.result
                    .map { $0.result }
                    >>> completion
        }
    }
}

private let decodingContext = CodingUserInfoKey(rawValue: "keyPath")!

private func decoder(keyPath: String) -> JSONDecoder {
    let decoder = JSONDecoder()
    let keyPath = keyPath
    decoder.userInfo[decodingContext] = keyPath
    return decoder
}

private struct Response<T: Decodable>: Decodable {
    let result: T
    
    struct ResponseResultKey: CodingKey {
        var stringValue: String
        init(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResponseResultKey.self)
        guard let keyPath = decoder.userInfo[decodingContext] as? String
            , let matchedKey = container.allKeys.filter({ $0.stringValue == keyPath }).first else {
                throw DecodingError.dataCorruptedError(forKey: ResponseResultKey.init(stringValue: decodingContext.rawValue),
                                                       in: container,
                                                       debugDescription: "Keypath \(decodingContext.rawValue) not found")
        }
        self.result = try container.decode(T.self, forKey: matchedKey)
    }
}

private struct PlayerSummariesResponse: Codable {
    let players: [SteamUser]
}

private struct GamesResponse: Codable {
    let games: [Game]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.games = (try? container.decode([Game].self, forKey: .games)) ?? []
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
