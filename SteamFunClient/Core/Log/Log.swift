//
//  Log.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 29.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

enum LogEvent {
    case openFlow
    case startNetworkRequest
    
    var messagePrefix: String {
        switch self {
        case .openFlow:
            return "[Flow][Open]"
        case .startNetworkRequest:
            return "[Network][Start request]"
        }
    }
}

func log(_ event: LogEvent, _ message: String) {
    print(event.messagePrefix + " " + message)
}

func log(_ error: Error) {
    print("[ERROR] \(error)")
}
