//
//  Steam.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

typealias SteamID = Int
typealias SteamID32 = Int
typealias GameID = Int

struct Steam { }

extension Steam {
    static var apiKey: String { "6E1AFE49F274E9B8398B47B5EF1F3180" }
    static var authPageLink: String { "https://steamcommunity.com/mobilelogin/" }
    static var profileLinkPrefix: String { "https://steamcommunity.com/profiles" }
}

enum SteamError: Error {
    case parsingError
}
