//
//  Dota2MatchHistoryPagedLoader.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation
import Alamofire

final class Dota2MatchHistoryPagedLoader {
    
    typealias Completion = (Result<[PlayerMatchHistory.Match], Error>) -> Void
    
    let steamID32: SteamID32
    let untilMatchID: MatchID?
    
    private var completion: Completion?
    private var matches: [PlayerMatchHistory.Match] = []
    
    init(steamID32: SteamID32, untilMatchID: MatchID? = nil) {
        self.steamID32 = steamID32
        self.untilMatchID = untilMatchID
    }
    
    func load(then completion: @escaping Completion) {
        self.completion = completion
        load(startingAt: nil)
    }
    
    private func load(startingAt startMatchID: MatchID?) {
        Steam.dota2MatchHistory(steamID32: steamID32, startAtMatchID: startMatchID) { [weak self] result in
            guard let self = self else { return }
            result.onSuccess {
                var newMatches = startMatchID == nil ? $0.matches : Array($0.matches.dropFirst())
                if newMatches.contains(where: { $0.id == self.untilMatchID }) || $0.remainingResultsCount == 0 {
                    newMatches = newMatches.prefix(while: { $0.id != self.untilMatchID })
                    self.matches.append(contentsOf: newMatches)
                    self.completion?(.success(self.matches))
                } else if $0.remainingResultsCount > 0, let lastMatchID = newMatches.last?.id {
                    self.matches.append(contentsOf: newMatches)
                    self.load(startingAt: lastMatchID)
                }
            }.onFailure {
                self.completion?(.failure($0))
            }
        }
    }
}
