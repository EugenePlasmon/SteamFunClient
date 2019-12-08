//
//  Dota2ModuleBuilder.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2ModuleBuilder {
    
    static func build(steamUser: SteamUser) -> Dota2ViewController {
        let matchesRequestManager = ServiceLocator.shared.matchesRequestManager(for: steamUser.id)
        
        let presenter = Dota2Presenter(steamUser: steamUser, matchesRequestManager: matchesRequestManager)
        let viewController = Dota2ViewController(output: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
