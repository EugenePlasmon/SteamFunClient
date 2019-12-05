//
//  Dota2MatchesPersistentStorage.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation
import RealmSwift

final class Dota2MatchesPersistentStorage {
    
    func store(_ model: Dota2UserMatches) throws {
        let realm = try Realm()
        let realmModel = try model.toRealmModel()
        try realm.write {
            realm.add(realmModel, update: .modified)
        }
    }
    
    func fetch(for steamID: SteamID) throws -> Dota2UserMatches? {
        let realm = try Realm()
        let fetchedObject = realm.object(ofType: RealmDota2UserMatches.self, forPrimaryKey: steamID)
        return fetchedObject?.toModel()
    }
}
