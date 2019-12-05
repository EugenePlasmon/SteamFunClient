//
//  Dota2Team.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 29.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

enum Dota2Team: String {
    
    case radiant
    case dire
    
    var logoName: String {
        switch self {
        case .radiant: return "radiant_icon"
        case .dire: return "dire_icon"
        }
    }
}
