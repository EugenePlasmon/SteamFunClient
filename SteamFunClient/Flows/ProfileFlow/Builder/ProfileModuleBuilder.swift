//
//  ProfileModuleBuilder.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

protocol ProfileModuleOutput: class {
    
    func profileDidLogout()
}

final class ProfileModuleBuilder {
    
    static func build(steamID: SteamID, output: ProfileModuleOutput?) -> ProfileViewController {
        let presenter = ProfilePresenter(steamID: steamID, output: output)
        let viewController = ProfileViewController(output: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
