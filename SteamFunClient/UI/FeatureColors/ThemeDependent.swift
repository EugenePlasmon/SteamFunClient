//
//  ThemeDependent.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

func themeDependent(dark: UIColor, light: UIColor) -> UIColor {
    let defaultTheme = dark
    if #available(iOS 13.0, *) {
        return UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark, .unspecified:
                return dark
            case .light:
                return light
            @unknown default:
                return defaultTheme
            }
        }
    } else {
        return defaultTheme
    }
}
