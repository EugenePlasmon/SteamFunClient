//
//  SteamUser.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct SteamUser: Codable {
    
    struct AvatarLinks: Codable {
        let small: String?
        let medium: String?
        let full: String?
        
        enum CodingKeys: String, CodingKey {
            case small = "avatar"
            case medium = "avatarmedium"
            case full = "avatarfull"
        }
    }
    
    enum CommunityVisibility: Int, Codable {
        case `private` = 1
        case friendsOnly = 2
        case `public` = 3
    }
    
    let id: SteamID
    let personName: String
    let realName: String?
    let countryCode: String?
    let creationDate: Date?
    let avatarLinks: AvatarLinks
    let communityVisibility: CommunityVisibility
    
    enum CodingKeys: String, CodingKey {
        case id = "steamid"
        case personName = "personaname"
        case realName = "realname"
        case creationDate = "timecreated"
        case countryCode = "loccountrycode"
        case communityVisibility = "communityvisibilitystate"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idString = try container.decode(String.self, forKey: .id)
        if let id = SteamID(idString) {
            self.id = id
        } else {
            throw SteamError.parsingError
        }
        self.personName = try container.decode(String.self, forKey: .personName)
        self.realName = try? container.decode(String.self, forKey: .realName)
        self.countryCode = try? container.decode(String.self, forKey: .countryCode)
        let creationDateTimestamp = try? container.decode(Double.self, forKey: .creationDate)
        self.creationDate = creationDateTimestamp >>- { Date(timeIntervalSince1970: $0) }
        self.avatarLinks = try AvatarLinks(from: decoder)
        self.communityVisibility = try container.decode(CommunityVisibility.self, forKey: .communityVisibility)
    }
}
