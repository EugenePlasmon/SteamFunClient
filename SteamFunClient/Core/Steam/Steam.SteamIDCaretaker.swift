//
//  Steam.SteamIDCaretaker.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation
import RealmSwift

extension Steam {
    
    final class SteamIDCaretaker {
        
        private(set) static var steamID: SteamID?
        
        static func store(_ steamID: SteamID) throws {
            let realm = try Realm()
            try realm.write {
                let fetchedObjects = realm.objects(SteamIDMemento.self)
                let storedObject = SteamIDMemento(steamID: steamID)
                realm.delete(fetchedObjects)
                realm.add(storedObject)
            }
            self.steamID = steamID
        }
        
        static func fetch() throws {
            let realm = try Realm()
            if let fetchedObject = realm.objects(SteamIDMemento.self).first {
                self.steamID = fetchedObject.steamID
            }
        }
        
        static func clear() throws {
            self.steamID = nil
            let realm = try Realm()
            try realm.write {
                let fetchedObjects = realm.objects(SteamIDMemento.self)
                realm.delete(fetchedObjects)
            }
        }
    }
}

final class SteamIDMemento: Object {
    @objc dynamic var steamID: SteamID
    init(steamID: SteamID) {
        self.steamID = steamID
    }
    required init() {
        self.steamID = 0
    }
}
