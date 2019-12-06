//
//  Double+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 07.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension Double {
    
    func rounded(toDigits digits: Int) -> Double {
        let multiplier = pow(10, Double(digits))
        return Double(Int(self * Double(multiplier))) / multiplier
    }
}

extension CGFloat {
    
    func rounded(toDigits digits: Int) -> CGFloat {
        let multiplier = pow(10, CGFloat(digits))
        return CGFloat(Int(self * CGFloat(multiplier))) / multiplier
    }
}
