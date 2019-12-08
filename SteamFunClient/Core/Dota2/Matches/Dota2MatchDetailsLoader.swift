//
//  Dota2MatchDetailsLoader.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class Dota2MatchDetailsLoader {
    
    // MARK: - Properties
    
    typealias Completion = ([MatchDetails]) -> Void
    typealias OnLoadingProgressClosure = (_ obtainedCount: Int, _ totalCount: Int) -> Void
    
    let matches: [PlayerMatchHistory.Match]
    
    var onLoadingProgress: OnLoadingProgressClosure?
    
    // MARK: - Private properties
    
    private var matchDetails: [MatchID: Either<MatchDetails, Error>] = [:]
    
    // MARK: - Init
    
    init(matches: [PlayerMatchHistory.Match]) {
        self.matches = matches
    }
    
    // MARK: - Methods
    
    func load(completion: @escaping Completion) {
        let chunks = self.matches.chunked(into: 50)
        recursivelyLoadChunkedMatches(chunks: chunks) { [weak self] in
            guard let self = self else { return }
            let sortedMatchDetails = self.matches.compactMap { self.matchDetails[$0.id]?.unwrap() as? MatchDetails }
            completion(sortedMatchDetails)
        }
    }
    
    // MARK: - Private
    
    private func recursivelyLoadChunkedMatches(chunks: [[PlayerMatchHistory.Match]], then completion: @escaping () -> Void) {
        if let chunk = chunks.first {
            loadDetails(for: chunk.map { $0.id }) { [weak self] in
                guard let self = self else {
                    completion()
                    return
                }
                let remainingChunks = Array(chunks.dropFirst())
                self.recursivelyLoadChunkedMatches(chunks: remainingChunks, then: completion)
            }
        } else {
            completion()
        }
    }
    
    private func loadDetails(for matchIDs: [MatchID], then completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        for matchID in matchIDs {
            dispatchGroup.enter()
            loadDetails(for: matchID) { dispatchGroup.leave() }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    private func loadDetails(for matchID: MatchID, then completion: @escaping () -> Void) {
        Steam.dota2MatchDetails(matchID: matchID) { [weak self] result in
            guard let self = self else {
                completion()
                return
            }
            result.onSuccess {
                self.matchDetails[matchID] = .firstType($0)
            }.onFailure {
                self.matchDetails[matchID] = .secondType($0)
                log($0, prefixMessage: "Error for matchID=\(matchID)")
            }
            let matchesTotalCount = self.matches.count
            let obtainedMatchesCount = self.matchDetails.keys.count
            self.onLoadingProgress?(obtainedMatchesCount, matchesTotalCount)
            completion()
        }
    }
}
