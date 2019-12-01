//
//  Game.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct Game: Codable {
    
    typealias Minutes = Int
    
    let id: GameID
    let name: String
    let playtimeLastTwoWeeks: Minutes
    let playtimeTotal: Minutes
    let iconUrl: String?
    let logoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "appid"
        case name
        case playtimeLastTwoWeeks = "playtime_2weeks"
        case playtimeTotal = "playtime_forever"
        case iconUrl = "img_icon_url"
        case logoUrl = "img_logo_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(GameID.self, forKey: .id)
        self.id = id
        self.name = try container.decode(String.self, forKey: .name)
        self.playtimeLastTwoWeeks = (try? container.decode(Minutes.self, forKey: .playtimeLastTwoWeeks)) ?? 0
        self.playtimeTotal = (try? container.decode(Minutes.self, forKey: .playtimeTotal)) ?? 0
        let iconUrlHash = try? container.decode(String.self, forKey: .iconUrl)
        self.iconUrl = iconUrlHash >>- { gameImageLink(id: String(id), hash: $0) }
        let logoUrlHash = try? container.decode(String.self, forKey: .logoUrl)
        self.logoUrl = logoUrlHash >>- { gameImageLink(id: String(id), hash: $0) }
    }
}

private func gameImageLink(id: String, hash: String) -> String? {
    let baseUrl = "http://media.steampowered.com/steamcommunity/public/images/apps/"
    return baseUrl
        .appending(pathComponent: id)
        .appending(pathComponent: hash)
        .appending(pathExtension: "jpg")
}
