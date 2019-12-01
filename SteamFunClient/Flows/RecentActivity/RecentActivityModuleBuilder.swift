//
//  RecentActivityModuleBuilder.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class RecentActivityModuleBuilder {
    
    static func build(steamID: SteamID) -> RecentActivityViewController {
        let presenter = RecentActivityPresenter(steamID: steamID)
        let viewController = RecentActivityViewController(output: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
