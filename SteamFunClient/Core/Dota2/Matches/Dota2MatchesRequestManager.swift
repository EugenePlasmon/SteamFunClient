//
//  Dota2MatchesRequestManager.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 02.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class Dota2MatchesRequestManager {
    
    let steamID: SteamID
    
    private let persistentStorage = Dota2MatchesPersistentStorage()
    private var matchHistoryLoader: Dota2MatchHistoryPagedLoader?
    private var matchDetailsLoader: Dota2MatchDetailsLoader?
    
    init(steamID: SteamID) {
        self.steamID = steamID
    }
    
    func getUserMatches(then completion: @escaping (Result<Dota2UserMatches, Error>) -> Void) {
        let storedUserMatches: Dota2UserMatches
        do {
            let fetchedUserMatches = try persistentStorage.fetch(for: steamID)
            storedUserMatches = fetchedUserMatches ?? Dota2UserMatches(steamID: steamID, matches: [])
        } catch {
            // TODO:
            print(error)
            storedUserMatches = Dota2UserMatches(steamID: steamID, matches: [])
        }
        
        let newestStoredMatch = storedUserMatches.matches.first
        
        let matchHistoryLoader = Dota2MatchHistoryPagedLoader(steamID32: steamID.to32,
                                                              untilMatchID: newestStoredMatch?.id)
        matchHistoryLoader.load { [weak self] result in
            guard let self = self else { return }
            result.onSuccess { newMatchesShortInfo in
                guard !newMatchesShortInfo.isEmpty else {
                    completion(.success(storedUserMatches))
                    return
                }
                
                let matchDetailsLoader = Dota2MatchDetailsLoader(matches: newMatchesShortInfo)
                matchDetailsLoader.load { matches in
                    let allMatches = matches + storedUserMatches.matches
                    let completedModel = Dota2UserMatches(steamID: self.steamID, matches: allMatches)
                    do {
                        try self.persistentStorage.store(completedModel)
                    } catch {
                        // TODO:
                        log(error)
                    }
                    completion(.success(completedModel))
                    self.matchDetailsLoader = nil
                }
                self.matchDetailsLoader = matchDetailsLoader
            }.onFailure {
                // TODO:
                log($0)
                completion(.failure($0))
            }
            self.matchHistoryLoader = nil
        }
        
        self.matchHistoryLoader = matchHistoryLoader
    }
}
