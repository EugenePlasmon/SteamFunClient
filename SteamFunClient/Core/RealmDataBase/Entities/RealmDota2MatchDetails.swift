//
//  RealmDota2MatchDetails.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmDota2MatchDetails: Object {
    
    @objc dynamic var id: Int = 0
    @objc dynamic var gameMode: Int = 0
    @objc dynamic var radiantWin: Bool = false
    let players = List<RealmDota2Player>()
    @objc dynamic var duration: Int = 0
    @objc dynamic var preGameDuration: Int = 0
    @objc dynamic var start: Date = Date()
    @objc dynamic var firstBloodTime: Int = 0
    @objc dynamic var humanPlayersCount: Int = 0
    @objc dynamic var radiantKills: Int = 0
    @objc dynamic var direKills: Int = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension RealmDota2MatchDetails {
    
    func toModel() -> MatchDetails {
        return MatchDetails(id: id,
                            gameMode: MatchDetails.GameMode(rawValue: gameMode)!,
                            winner: radiantWin ? .radiant : .dire,
                            players: players.map { $0.toModel() },
                            duration: duration,
                            preGameDuration: preGameDuration,
                            start: start,
                            firstBloodTime: firstBloodTime,
                            humanPlayersCount: humanPlayersCount,
                            kills: [.radiant: radiantKills,
                                    .dire: direKills])
    }
}

extension MatchDetails {

    func toRealmModel() throws -> RealmDota2MatchDetails {
        let model = RealmDota2MatchDetails()
        model.id = id
        model.gameMode = gameMode.rawValue
        model.radiantWin = winner == .radiant
        model.players.append(objectsIn: players.map { $0.toRealmModel() })
        model.duration = duration
        model.preGameDuration = preGameDuration
        model.start = start
        model.firstBloodTime = firstBloodTime
        model.humanPlayersCount = humanPlayersCount
        model.radiantKills = kills[.radiant] ?? 0
        model.direKills = kills[.dire] ?? 0
        return model
    }
}
