//
//  RealmDota2UserMatches.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmDota2UserMatches: Object {
    
    @objc dynamic var steamID: Int64 = 0
    let matches = List<RealmDota2MatchDetails>()
    
    override class func primaryKey() -> String? {
        return "steamID"
    }
}

extension RealmDota2UserMatches {
    
    func toModel() -> Dota2UserMatches {
        return Dota2UserMatches(steamID: steamID,
                                matches: matches.map { $0.toModel() })
    }
}

extension Dota2UserMatches {

    func toRealmModel() throws -> RealmDota2UserMatches {
        let model = RealmDota2UserMatches()
        model.steamID = steamID
        model.matches.append(objectsIn: try matches.map { try $0.toRealmModel() })
        return model
    }
}
