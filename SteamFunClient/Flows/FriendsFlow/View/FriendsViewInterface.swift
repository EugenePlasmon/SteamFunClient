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
        var state: State
        let onWillDisplay: (Cell) -> Void
        enum State {
            case loading
            case data(name: String, realName: String?, avatarLink: String?)
        }
    }
    
    let title: String
    let avatarLink: String?
    var cells: [Cell]
}

protocol FriendsViewInput: class {
    
    func showData(viewModel: FriendsViewModel)
    
    func updateCellsData(cells: [FriendsViewModel.Cell], updatedAt index: Int)
}

protocol FriendsViewOutput: class {
    
    func viewDidLoad()
    
    func viewDidSelectFriend(with id: SteamID)
}
