//
//  Dota2MatchesRequestManager.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 02.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class Dota2MatchesRequestManager {
    
    // MARK: - Properties
    
    let steamID: SteamID
    
    enum LoadProgress: Equatable {
        case notStarted
        case fetchedFromDatabase
        case fullMatchHistoryObtained
        case matchDetailsRequesting(obtainedCount: Int, totalCount: Int)
        case finished
    }
    
    private(set) var loadProgress: LoadProgress = .notStarted {
        didSet {
            guard loadProgress != oldValue else { return }
            onLoadProgressChange?(loadProgress)
        }
    }
    
    var onLoadProgressChange: ((LoadProgress) -> Void)?
    
    // MARK: - Private properties
    
    private let persistentStorage = Dota2MatchesPersistentStorage()
    private var matchHistoryLoader: Dota2MatchHistoryPagedLoader?
    private var matchDetailsLoader: Dota2MatchDetailsLoader?
    
    // MARK: - Init
    
    init(steamID: SteamID) {
        self.steamID = steamID
    }
    
    func getUserMatches(then completion: @escaping (Result<Dota2UserMatches, Error>) -> Void) {
        let storedUserMatches = fetchMatchesFromDatabase()
        loadProgress = .fetchedFromDatabase
        
        let newestStoredMatch = storedUserMatches.matches.first
        
        let matchHistoryLoader = Dota2MatchHistoryPagedLoader(steamID32: steamID.to32,
                                                              untilMatchID: newestStoredMatch?.id)
        matchHistoryLoader.load { [weak self] result in
            guard let self = self else { return }
            result.onSuccess { newMatchesShortInfo in
                guard !newMatchesShortInfo.isEmpty else {
                    self.loadProgress = .finished
                    completion(.success(storedUserMatches))
                    return
                }
                
                self.loadProgress = .fullMatchHistoryObtained
                
                let matchDetailsLoader = Dota2MatchDetailsLoader(matches: newMatchesShortInfo)
                matchDetailsLoader.onLoadingProgress = { (obtained, total) in
                    self.loadProgress = .matchDetailsRequesting(obtainedCount: obtained, totalCount: total)
                }
                matchDetailsLoader.load { matches in
                    let allMatches = matches + storedUserMatches.matches
                    let completedModel = Dota2UserMatches(steamID: self.steamID, matches: allMatches)
                    do {
                        try self.persistentStorage.store(completedModel)
                    } catch {
                        log(error)
                    }
                    self.loadProgress = .finished
                    completion(.success(completedModel))
                    self.matchDetailsLoader = nil
                }
                self.matchDetailsLoader = matchDetailsLoader
            }.onFailure {
                self.loadProgress = .finished
                completion(.failure($0))
            }
            self.matchHistoryLoader = nil
        }
        
        self.matchHistoryLoader = matchHistoryLoader
    }
    
    // MARK: - Private
    
    private func fetchMatchesFromDatabase() -> Dota2UserMatches {
        let storedUserMatches: Dota2UserMatches
        do {
            let fetchedUserMatches = try persistentStorage.fetch(for: steamID)
            storedUserMatches = fetchedUserMatches ?? Dota2UserMatches(steamID: steamID, matches: [])
        } catch {
            log(error)
            storedUserMatches = Dota2UserMatches(steamID: steamID, matches: [])
        }
        return storedUserMatches
    }
}
