//
//  Steam.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

typealias SteamID = Int64
typealias SteamID32 = Int
typealias GameID = Int
typealias MatchID = Int64

extension SteamID {
    
    var to32: SteamID32 {
        let baseSteamID64: SteamID = 76561197960265728
        return SteamID32(self - baseSteamID64)
    }
}

struct Steam { }

extension Steam {
    static var apiKey: String { "6E1AFE49F274E9B8398B47B5EF1F3180" }
    static var authPageLink: String { "https://steamcommunity.com/mobilelogin/" }
    static var profileLinkPrefix: String { "https://steamcommunity.com/profiles" }
}

extension Steam {
    
    enum Error: Swift.Error {
        case dataCorrupted
        case parsingError
        case userHasntAllowed
        case noGameStats
        case unknownGameMode
    }
}

