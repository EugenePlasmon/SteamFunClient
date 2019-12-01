//
//  Dota2Hero.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 02.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct Dota2Hero {
    
    let id: Int
    let apiName: String
    let name: String
    
    var iconName: String? {
        return name >>- { $0.replacingOccurrences(of: " ", with: "_") + "_icon" }
    }
    
    init?(id: Int) {
        if let hero = Dota2HeroResourceManager.shared.hero(id: id) {
            self = hero
        } else {
            return nil
        }
    }
    
    private static func name(fromApiName apiName: String) -> String? {
        let apiNamePrefix = "npc_dota_hero_"
        guard apiName.hasPrefix(apiNamePrefix) else { return nil }
        let snakeCaseName = String(apiName.dropFirst(apiNamePrefix.count))
        return snakeCaseName.components(separatedBy: "_")
            .map { $0.capitalized }
            .joined(separator: " ")
    }
}

// MARK: - Decodable

extension Dota2Hero: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id
        case apiName = "name"
        case name = "localized_name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        let apiName = try container.decode(String.self, forKey: .apiName)
        self.apiName = apiName
        self.name = (try? container.decode(String.self, forKey: .name)) ?? Dota2Hero.name(fromApiName: apiName) ?? ""
    }
}

