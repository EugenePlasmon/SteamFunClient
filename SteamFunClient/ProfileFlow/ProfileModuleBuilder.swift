//
//  ProfileModuleBuilder.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class ProfileModuleBuilder {
    
    static func build(steamID: SteamID) -> ProfileViewController {
        let presenter = ProfilePresenter(steamID: steamID)
        let viewController = ProfileViewController(output: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
