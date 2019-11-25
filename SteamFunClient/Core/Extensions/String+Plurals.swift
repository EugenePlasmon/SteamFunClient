//
//  String+Plurals.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 27.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

extension String {
    
    public static func plural(forCount count: Int, zeroFiveTen: String, one: String, twoFour: String, includeNumber: Bool = false) -> String {
        let unsignedCount = UInt(abs(count))
        var lastDigits = unsignedCount % 100
        var returnString = ""
        if lastDigits >= 11 && lastDigits <= 19 {
            returnString = zeroFiveTen
        } else {
            lastDigits = lastDigits % 10
            if lastDigits == 1 {
                returnString = one
            } else if (lastDigits >= 2) && (lastDigits <= 4) {
                returnString = twoFour
            } else {
                returnString = zeroFiveTen
            }
        }
        return includeNumber ? String("\(count)\u{00A0}\(returnString)") : returnString
    }
}
