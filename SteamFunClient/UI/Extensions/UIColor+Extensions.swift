//
//  UIColor+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 05.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public extension UIColor {
    
    typealias RedGreenBlueTuple = (red: CGFloat, green: CGFloat, blue: CGFloat)
    var redGreenBlue: RedGreenBlueTuple {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red, green, blue)
    }
    
    func darken(by: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return .init(hue: hue, saturation: saturation, brightness: max(brightness - by, 0), alpha: alpha)
    }
    
    func lighten(by: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return .init(hue: hue, saturation: saturation, brightness: min(brightness + by, 1), alpha: alpha)
    }
}
