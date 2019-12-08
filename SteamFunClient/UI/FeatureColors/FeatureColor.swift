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
        
        static let infoText = themeDependent(dark: .tassadar, light: .aldaris)
    }
}

extension FeatureColor {
    
    struct Dota2 {
        
        static let background = themeDependent(dark: .vorazun, light: .artanis)
        
        static let errorText = themeDependent(dark: .tassadar, light: .aldaris)
    }
    
    struct Dota2ShortStats {
        
        static let title = themeDependent(dark: .artanis, light: .aldaris)
        
        static let background = themeDependent(dark: .raszagal, light: .zoraya)
        
        static let statTitle = themeDependent(dark: .artanis, light: .aldaris)
        
        static let statSubtitle = themeDependent(dark: .selendis, light: .serdath)
        
        static let moreButton = themeDependent(dark: .artanis, light: .aldaris)
    }
    
    struct Dota2MatchHistory {
        
        static let headerTexts = themeDependent(dark: .artanis, light: .vorazun)
        
        struct Cell {
            
            static let background = themeDependent(dark: .raszagal, light: .zoraya)
            
            static let heroName = themeDependent(dark: .tassadar, light: .aldaris)
            
            static let heroStroke = themeDependent(dark: .rohana, light: .rohana)
            
            static let team = themeDependent(dark: .tassadar, light: .aldaris)
            
            static let win = themeDependent(dark: .dabiri, light: .dabiri)
            
            static let lose = themeDependent(dark: .rastadon, light: .rastadon)
            
            static let date = themeDependent(dark: .tassadar, light: .aldaris)
        }
        
    }
}

extension FeatureColor {
    
    struct Dota2Stats {
        
        static let background = themeDependent(dark: .vorazun, light: .artanis)
        
        static let blockTitle = themeDependent(dark: .artanis, light: .aldaris)
        
        static let blockBackground = themeDependent(dark: .raszagal, light: .zoraya)
        
        struct Plot {
            
            static let title = themeDependent(dark: .artanis, light: .aldaris)
            
            static let background = themeDependent(dark: .nyon, light: .zeratul)
            
            static let line = themeDependent(dark: .rohana, light: .nyon)
            
            static let value = themeDependent(dark: .artanis, light: .aldaris)
            
            static let day = themeDependent(dark: .artanis, light: .aldaris)
        }
        
        struct TopHeroes {
            
            static let title = themeDependent(dark: .artanis, light: .aldaris)
            
            static let columnBackground = themeDependent(dark: .nyon, light: .zeratul)
            
            static let columnValue = themeDependent(dark: .artanis, light: .aldaris)
        }
    }
}

extension FeatureColor {
    
    struct Achievements {
        
        static let gameName = themeDependent(dark: .artanis, light: .artanis)
        
        static let playerProgress = themeDependent(dark: .artanis, light: .artanis)
        
        static let playerProgressBackground = themeDependent(dark: .serdath, light: .serdath)
        
        static let achievementCell = themeDependent(dark: .raszagal, light: .zoraya)
        
        static let achievementName = themeDependent(dark: .artanis, light: .vorazun)
        
        static let achievementPercentage = themeDependent(dark: .selendis, light: .serdath)
        
        static let achievementDescription = themeDependent(dark: .selendis, light: .serdath)
    }
}
