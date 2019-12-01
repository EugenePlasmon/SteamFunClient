//
//  FeatureColor.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

struct FeatureColor { }

extension FeatureColor {
    
    struct Profile {
        
        static let name = themeDependent(dark: .artanis, light: .artanis)
        
        static let realName = themeDependent(dark: .tassadar, light: .artanis)
        
        static let actionButtonDefault = themeDependent(dark: .artanis, light: .artanis)
        
        static let actionButtonPressed = themeDependent(dark: .selendis, light: .selendis)
        
        static let background = themeDependent(dark: .vorazun, light: .artanis)
        
        static let gamesListTitle = themeDependent(dark: .artanis, light: .aldaris)
        
        static let dota2Title = themeDependent(dark: .artanis, light: .artanis)
        
        static let dota2Subtitle = themeDependent(dark: .artanis, light: .artanis)
        
        static let gameName = themeDependent(dark: .artanis, light: .vorazun)
        
        static let gamePlaytime = themeDependent(dark: .selendis, light: .serdath)
        
        static let gameCell = themeDependent(dark: .raszagal, light: .zoraya)
    }
}

extension FeatureColor {
    
    struct Navbar {
        
        static let background = themeDependent(dark: .zeratul, light: .zeratul)
    }
}

extension FeatureColor {
    
    struct Tabbar {
        
        static let item = themeDependent(dark: .artanis, light: .artanis)
        
        static let unselectedItem = themeDependent(dark: .selendis, light: .selendis)
            
        static let background = themeDependent(dark: .fenix, light: .fenix)
    }
}

extension FeatureColor {
    
    struct Throbber {
        
        static let barBackground = themeDependent(dark: .zeratul, light: .zeratul)
        
        static let background = themeDependent(dark: .raszagal, light: .artanis)
    }
}

extension FeatureColor {
    
    struct Friends {
        
        static let navbarTitle = themeDependent(dark: .artanis, light: .artanis)
        
        static let background = themeDependent(dark: .vorazun, light: .artanis)
        
        static let avatarBar = themeDependent(dark: .mohandar, light: .imrian)
        
        static let friendName = themeDependent(dark: .artanis, light: .vorazun)
        
        static let friendRealName = themeDependent(dark: .selendis, light: .serdath)
        
        static let friendCell = themeDependent(dark: .raszagal, light: .zoraya)
    }
}

extension FeatureColor {
    
    struct RecentActivity {
        
        static let background = themeDependent(dark: .vorazun, light: .artanis)
        
        static let gameCell = themeDependent(dark: .raszagal, light: .zoraya)
        
//        static let name = themeDependent(dark: .artanis, light: .artanis)
//
//        static let realName = themeDependent(dark: .tassadar, light: .artanis)
//
//        static let actionButtonDefault = themeDependent(dark: .artanis, light: .artanis)
//
//        static let actionButtonPressed = themeDependent(dark: .selendis, light: .selendis)
//
//
//        static let gamesListTitle = themeDependent(dark: .artanis, light: .aldaris)
//
//        static let dota2Title = themeDependent(dark: .artanis, light: .artanis)
//
//        static let dota2Subtitle = themeDependent(dark: .artanis, light: .artanis)
//
//        static let gameName = themeDependent(dark: .artanis, light: .vorazun)
//
//        static let gamePlaytime = themeDependent(dark: .selendis, light: .serdath)
//
//        static let gameCell = themeDependent(dark: .raszagal, light: .zoraya)
    }
}
