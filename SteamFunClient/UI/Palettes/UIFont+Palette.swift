//
//  UIFont+Palette.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension UIFont {
    
    static let kerrigan = UIFont.Family<Helvetica>.font(.bold, size: 24.0)
    
    static let izsha = UIFont.Family<Helvetica>.font(.bold, size: 20.0)
    
    static let stukov = UIFont.Family<Helvetica>.font(.medium, size: 20.0)
    
    static let dehaka = UIFont.Family<Helvetica>.font(.regular, size: 20.0)
    
    static let ryloth = UIFont.Family<Helvetica>.font(.bold, size: 16.0)
    
    static let naktul = UIFont.Family<Helvetica>.font(.medium, size: 16.0)
    
    static let abathur = UIFont.Family<Helvetica>.font(.regular, size: 16.0)
    
    static let nafash = UIFont.Family<Helvetica>.font(.bold, size: 14.0)
    
    static let brakk = UIFont.Family<Helvetica>.font(.medium, size: 14.0)
    
    static let zagara = UIFont.Family<Helvetica>.font(.regular, size: 14.0)
    
    static let zurvan = UIFont.Family<Helvetica>.font(.medium, size: 12.0)
    
    static let niadra = UIFont.Family<Helvetica>.font(.regular, size: 10.0)
}

private extension UIFont {
    
    struct Family<T: FontFamily> {
        
        static func font(_ family: T, size: CGFloat) -> UIFont {
            return UIFont(name: family.fontName, size: size) ?? UIFont.systemFont(ofSize: size)
        }
    }
}

private enum Helvetica: String, FontFamily {
    case thin = "Thin"
    case light = "Light"
    case regular = ""
    case medium = "Medium"
    case bold = "Bold"
    
    static var familyName: String {
        return "HelveticaNeue"
    }
}

private protocol FontFamily: RawRepresentable where RawValue == String {
    static var familyName: String { get }
    var fontName: String { get }
}

extension FontFamily {
    var fontName: String {
        return Self.familyName + (!self.rawValue.isEmpty ? "-\(self.rawValue)" : "")
    }
}
