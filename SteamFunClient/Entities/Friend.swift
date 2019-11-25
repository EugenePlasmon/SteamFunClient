//
//  Friend.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 26.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct Friend: Codable {
    
    let id: SteamID
    let friendSince: Date
    
    enum CodingKeys: String, CodingKey {
        case id = "steamid"
        case friendSince = "friend_since"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        if let id = SteamID(idString) {
            self.id = id
        } else {
            throw SteamError.parsingError
        }
        let friendSinceTimestamp = try container.decode(Double.self, forKey: .friendSince)
        self.friendSince = Date(timeIntervalSince1970: friendSinceTimestamp)
    }
}
