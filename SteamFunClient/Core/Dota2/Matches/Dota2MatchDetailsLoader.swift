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
    
    private var completion: Completion?
    private var matchDetails: [Int: MatchDetails] = [:]
    
    init(matches: [PlayerMatchHistory.Match]) {
        self.matches = matches
    }
    
    func load(completion: @escaping Completion) {
        self.completion = completion
        
        let dispatchGroup = DispatchGroup()
        for match in matches {
            dispatchGroup.enter()
            loadDetails(for: match.id) { dispatchGroup.leave() }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let sortedMatchDetails = self.matches.compactMap { self.matchDetails[$0.id] }
            self.completion?(sortedMatchDetails)
        }
    }
    
    private func loadDetails(for matchID: Int, then completion: @escaping () -> Void) {
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
            }
            completion()
        }
    }
}
