//
//  OwnedGame.Minutes+Format.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 26.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

extension OwnedGame.Minutes {
    
    var hoursAndMinutes: String {
        let minutes = self % 60
        let hours = (self - minutes) / 60
        switch (hours, minutes) {
        case (0, let minutes):
            return "\(minutes) мин"
        case (let hours, 0):
            return "\(hours) ч"
        default:
            return "\(hours) ч \(minutes) мин"
        }
    }
}
