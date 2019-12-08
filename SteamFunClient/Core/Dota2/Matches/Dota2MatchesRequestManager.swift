//
//  Dota2MatchesRequestManager.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 02.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class Dota2MatchesRequestManager {
    
    // MARK: - Get Properties
    
    let steamID: SteamID
    
    typealias RequestResult = Result<Dota2UserMatches, Error>
    
    enum LoadProgress {
        case notStarted
        case fetchedFromDatabase
        case fullMatchHistoryObtained
        case matchDetailsRequesting(obtainedCount: Int, totalCount: Int)
        case finished(result: RequestResult)
    }
    
    private(set) var loadProgress: LoadProgress = .notStarted {
        didSet {
            guard loadProgress != oldValue else { return }
            onLoadProgressChange?(loadProgress)
        }
    }
    
    // MARK: - Callbacks
    
    typealias Completion = (RequestResult) -> Void
    typealias OnLoadProgressChangeClosure = (LoadProgress) -> Void
    
    var onLoadProgressChange: OnLoadProgressChangeClosure?
    var completion: Completion?
    
    // MARK: - Private properties
    
    private let persistentStorage = Dota2MatchesPersistentStorage()
    private var matchHistoryLoader: Dota2MatchHistoryPagedLoader?
    private var matchDetailsLoader: Dota2MatchDetailsLoader?
    
    // MARK: - Init
    
    init(steamID: SteamID) {
        self.steamID = steamID
    }
    
    // MARK: - Methods
    
    func getUserMatches(forceCompletionIfFinished: Bool = true) {
        switch loadProgress {
        case .notStarted:
            getUserMatchesForced()
        case .fetchedFromDatabase, .fullMatchHistoryObtained, .matchDetailsRequesting:
            return
        case .finished(let result):
            if forceCompletionIfFinished {
                completion?(result)
            }
        }
    }
    
    func getUserMatchesForced() {
        let storedUserMatches = fetchMatchesFromDatabase()
        loadProgress = .fetchedFromDatabase
        
        let newestStoredMatch = storedUserMatches.matches.first
        
        let matchHistoryLoader = Dota2MatchHistoryPagedLoader(steamID32: steamID.to32,
                                                              untilMatchID: newestStoredMatch?.id)
        matchHistoryLoader.load { [weak self] result in
            guard let self = self else { return }
            result.onSuccess { newMatchesShortInfo in
                guard !newMatchesShortInfo.isEmpty else {
                    let result = RequestResult.success(storedUserMatches)
                    self.loadProgress = .finished(result: result)
                    self.completion?(result)
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
                    
                    let result = RequestResult.success(completedModel)
                    self.loadProgress = .finished(result: result)
                    self.completion?(result)
                    self.matchDetailsLoader = nil
                }
                self.matchDetailsLoader = matchDetailsLoader
            }.onFailure {
                let result = RequestResult.failure($0)
                self.loadProgress = .finished(result: result)
                self.completion?(result)
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

extension Dota2MatchesRequestManager.LoadProgress: Equatable {
    
    static func == (lhs: Dota2MatchesRequestManager.LoadProgress, rhs: Dota2MatchesRequestManager.LoadProgress) -> Bool {
        switch (lhs, rhs) {
        case (.notStarted, notStarted),
             (.fetchedFromDatabase, .fetchedFromDatabase),
             (.fullMatchHistoryObtained, .fullMatchHistoryObtained):
            return true
        case (.matchDetailsRequesting(let lhsObtainedCount, let lhsTotalCount),
              .matchDetailsRequesting(let rhsObtainedCount, let rhsTotalCount)):
            return lhsObtainedCount == rhsObtainedCount && lhsTotalCount == rhsTotalCount
        case (.finished, .finished):
            return true
        default:
            return false
        }
    }
}
