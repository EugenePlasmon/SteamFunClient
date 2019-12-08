//
//  Dota2MatchDetailsLoader.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class Dota2MatchDetailsLoader {
    
    typealias Completion = ([MatchDetails]) -> Void
    
    let matches: [PlayerMatchHistory.Match]
    
    private var matchDetails: [MatchID: MatchDetails] = [:]
    
    init(matches: [PlayerMatchHistory.Match]) {
        self.matches = matches
    }
    
    func load(completion: @escaping Completion) {
        let chunks = self.matches.chunked(into: 50)
        recursivelyLoadChunkedMatches(chunks: chunks) { [weak self] in
            guard let self = self else { return }
            let sortedMatchDetails = self.matches.compactMap { self.matchDetails[$0.id] }
            completion(sortedMatchDetails)
        }
    }
    
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
                self.matchDetails[matchID] = $0
            }.onFailure {
                // TODO:
                log($0)
                print("Error for matchID=\(matchID)")
            }
            completion()
        }
    }
}
