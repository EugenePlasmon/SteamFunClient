//
//  FriendsModuleBuilder.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class FriendsModuleBuilder {
    
    static func build(friends: [Friend], ofUser user: SteamUser) -> FriendsViewController {
        let presenter = FriendsPresenter(friends: friends, ofUser: user)
        let viewController = FriendsViewController(output: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
