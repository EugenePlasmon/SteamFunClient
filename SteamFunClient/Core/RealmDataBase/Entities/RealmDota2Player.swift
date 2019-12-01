//
//  RealmDota2Player.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmDota2Player: Object {
    
    let accountID = RealmOptional<Int>()
    @objc dynamic var slot: Int = 0
    @objc dynamic var heroID: Int = 0
    @objc dynamic var kills: Int = 0
    @objc dynamic var deaths: Int = 0
    @objc dynamic var assists: Int = 0
    let leaverStatus = RealmOptional<Int>()
    @objc dynamic var lastHits: Int = 0
    @objc dynamic var denies: Int = 0
    @objc dynamic var goldPerMin: Int = 0
    @objc dynamic var xpPerMin: Int = 0
    @objc dynamic var level: Int = 0
    @objc dynamic var playerName: String? = nil
}

extension RealmDota2Player {
    
    func toModel() -> MatchDetails.Player {
        return MatchDetails.Player(accountID: accountID.value,
                                   slot: MatchDetails.Player.Slot(rawValue: slot)!,
                                   heroID: heroID,
                                   kills: kills,
                                   deaths: deaths,
                                   assists: assists,
                                   leaverStatus: leaverStatus.value,
                                   lastHits: lastHits,
                                   denies: denies,
                                   goldPerMin: goldPerMin,
                                   xpPerMin: xpPerMin,
                                   level: level,
                                   playerName: playerName)
    }
}

extension MatchDetails.Player {
    
    func toRealmModel() -> RealmDota2Player {
        let model = RealmDota2Player()
        model.accountID.value = accountID
        model.slot = slot.rawValue
        model.heroID = heroID
        model.kills = kills
        model.deaths = deaths
        model.assists = assists
        model.leaverStatus.value = leaverStatus
        model.lastHits = lastHits
        model.denies = denies
        model.goldPerMin = goldPerMin
        model.xpPerMin = xpPerMin
        model.level = level
        model.playerName = playerName
        return model
    }
}
