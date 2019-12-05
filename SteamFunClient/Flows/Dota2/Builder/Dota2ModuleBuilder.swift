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
        let presenter = Dota2Presenter(steamUser: steamUser)
        let viewController = Dota2ViewController(output: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
