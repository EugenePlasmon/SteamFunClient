//
//  ProfileViewInterface.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 27.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct ProfileViewModel {
    
    let isHiddenProfile: Bool
    let name: String
    let realName: String?
    let avatarLink: String?
    let friendsCount: Int
    let ownedGames: [Game]
}

protocol ProfileViewInput: class {
    
    func showLoader()
    
    func showData(viewModel: ProfileViewModel)
}

protocol ProfileViewOutput: class {
    
    func viewDidLoad()
    
    func viewDidTapFriends()
    
    func viewDidTapLogout()
}
