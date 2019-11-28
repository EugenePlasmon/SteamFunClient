//
//  FriendsViewInterface.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

struct FriendsViewModel {
    
    struct Cell {
        let steamID: SteamID
        let name: String
        let realName: String?
        let avatarLink: String?
    }
    
    let title: String
    let avatarLink: String?
    let cells: [Cell]
}

protocol FriendsViewInput: class {
    
    func showLoader()
    
    func showData(viewModel: FriendsViewModel)
}

protocol FriendsViewOutput: class {
    
    func viewDidLoad()
    
    func viewDidSelectFriend(with id: SteamID)
}
