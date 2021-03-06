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
        
        Steam.Endpoint.playerSummaries(id: steamID).request
            .responseDecodable(of: Response<PlayerSummariesResponse>.self, decoder: decoder(keyPath: "response")) { dataResponse in
                dataResponse.result
                    .map { $0.result.players.first! }
                    >>> completion
        }
    }
    
    static func getFriends(for steamID: SteamID,
                           then completion: @escaping (Result<[Friend], AFError>) -> Void) {
        
        Steam.Endpoint.friendsList(id: steamID).request
            .responseDecodable(of: FriendsList.self) { dataResponse in
                dataResponse.result
                    .map { $0.friendsList.friends }
                    >>> completion
        }
    }
    
    static func getOwnedGames(for steamID: SteamID,
                              then completion: @escaping (Result<[Game], AFError>) -> Void) {
        
        Steam.Endpoint.playerOwnedGames(id: steamID).request
            .responseDecodable(of: Response<GamesResponse>.self, decoder: decoder(keyPath: "response")) { dataResponse in
                dataResponse.result
                    .map { $0.result.games }
                    >>> completion
        }
    }
    
    static func getPlayerGameAchievements(steamID: SteamID,
                                          gameID: GameID,
                                          then completion: @escaping (Result<PlayerGameAchievements, Swift.Error>) -> Void) {
        
        Steam.Endpoint.playerGameAchievements(steamID: steamID, gameID: gameID).request
            .responseDecodable(of: Response<Either<PlayerGameAchievements, ResponseError>>.self, decoder: decoder(keyPath: "playerstats")) { dataResponse in
                dataResponse.result.onSuccess { response in
                    let either = response.result
                    switch either {
                    case .firstType(let model):
                        completion(.success(model))
                    case .secondType(let error):
                        if !error.success {
                            completion(.failure(Steam.Error.noGameStats))
                        } else {
                            completion(.failure(Steam.Error.parsingError))
                        }
                    }
                }.onFailure {
                    completion(.failure($0))
                }
        }
    }
    
    static func getGlobalAchievementPercentages(gameID: GameID,
                                                then completion: @escaping (Result<GlobalAchievementPercentages, AFError>) -> Void) {
        
        Steam.Endpoint.globalAchievementPercentages(gameID: gameID).request
            .responseDecodable(of: Response<GlobalAchievementPercentages>.self, decoder: decoder(keyPath: "achievementpercentages")) { dataResponse in
                dataResponse.result
                    .map { $0.result }
                    >>> completion
        }
    }
    
    static func getRecentlyPlayedGames(steamID: SteamID,
                                       then completion: @escaping (Result<[Game], AFError>) -> Void) {
        
        Steam.Endpoint.recentlyPlayedGames(steamID: steamID).request
            .responseDecodable(of: Response<GamesResponse>.self, decoder: decoder(keyPath: "response")) { dataResponse in
                dataResponse.result
                    .map { $0.result.games }
                    >>> completion
        }
    }
    
    static func getGameSchema(gameID: GameID,
                              then completion: @escaping (Result<GameSchema, AFError>) -> Void) {
        
        Steam.Endpoint.gameSchema(gameID: gameID).request
            .responseDecodable(of: Response<GameSchema>.self, decoder: decoder(keyPath: "game")) { dataResponse in
                dataResponse.result
                    .map { $0.result }
                    >>> completion
        }
    }
    
    static func dota2Heroes(then completion: @escaping (Result<[Dota2Hero], AFError>) -> Void) {
        
        Steam.Endpoint.dota2Heroes.request
            .responseDecodable(of: Response<Heroes>.self, decoder: decoder(keyPath: "result")) { dataResponse in
                dataResponse.result
                    .map { $0.result.heroes }
                    >>> completion
        }
    }
    
    static func dota2MatchHistory(steamID32: SteamID32,
                                  heroID: Int? = nil,
                                  startAtMatchID: MatchID? = nil,
                                  batchSize: Int? = nil,
                                  then completion: @escaping (Result<PlayerMatchHistory, Swift.Error>) -> Void) {
        
        Steam.Endpoint.dota2MatchHistory(steamID32: steamID32,
                                         heroID: heroID,
                                         startAtMatchID: startAtMatchID,
                                         batchSize: batchSize)
            .request.responseDecodable(of: Response<Either<PlayerMatchHistory, ResponseErrorWithStatus>>.self, decoder: decoder(keyPath: "result")) { dataResponse in
                
                dataResponse.result.onSuccess { response in
                    let either = response.result
                    switch either {
                    case .firstType(let matchHistory):
                        completion(.success(matchHistory))
                    case .secondType(let matchHistoryError):
                        if matchHistoryError.status == 15 {
                            completion(.failure(Steam.Error.userHasntAllowed))
                        } else {
                            completion(.failure(Steam.Error.parsingError))
                        }
                    }
                }.onFailure {
                    completion(.failure($0))
                }
        }
    }
    
    static func dota2MatchDetails(matchID: MatchID,
                                  then completion: @escaping (Result<MatchDetails, AFError>) -> Void) {
        
        Steam.Endpoint.dota2MatchDetails(matchID: matchID).request
            .responseDecodable(of: Response<MatchDetails>.self, decoder: decoder(keyPath: "result")) { dataResponse in
                dataResponse.result
                    .map { $0.result }
                    >>> completion
        }
    }
}

// MARK: - Private

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

private struct Heroes: Decodable {
    let heroes: [Dota2Hero]
}

private struct ResponseError: Decodable {
    let error: String
    let success: Bool
}

private struct ResponseErrorWithStatus: Decodable {
    let status: Int
    let statusDetail: String
}
