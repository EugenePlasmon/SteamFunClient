//
//  FriendsPresenter.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class FriendsPresenter {
    
    weak var viewInput: (UIViewController & FriendsViewInput)?
    let user: SteamUser
    let friends: [Friend]
    
    init(friends: [Friend], ofUser user: SteamUser) {
        self.friends = friends
        self.user = user
    }
    
    private lazy var initialViewModel: FriendsViewModel = {
        let cells = friends.compactMap { friend in
            FriendsViewModel.Cell(steamID: friend.id, state: .loading, onWillDisplay: { [weak self] cell in self?.willDisplayCell(cell) })
        }
        return FriendsViewModel(title: "Друзья " + user.personName,
                                avatarLink: user.avatarLinks.full,
                                cells: cells)
    }()
    
    private lazy var viewModel = initialViewModel
    
    private func willDisplayCell(_ cell: FriendsViewModel.Cell) {
        guard case .loading = cell.state else { return }
        Steam.getProfileInfo(for: cell.steamID) { [weak self] result in
            guard let self = self else { return }
            result.onSuccess {
                guard case (let i, var cell)? = self.viewModel.cells.enumerated().first(where: { $1.steamID == cell.steamID }) else {
                    return
                }
                cell.state = .data(name: $0.personName, realName: $0.realName, avatarLink: $0.avatarLinks.full)
                self.updateCell(at: i, with: cell)
            }.onFailure {
                // TODO:
                log($0)
            }
        }
    }
    
    private func updateCell(at index: Int, with cell: FriendsViewModel.Cell) {
        viewModel.cells[index] = cell
        viewInput?.updateCellsData(cells: viewModel.cells, updatedAt: index)
        
    }
}

extension FriendsPresenter: FriendsViewOutput {
    
    func viewDidLoad() {
        log(.openFlow, "Friends (of user steamID=\(user.id))")
        self.viewInput?.showData(viewModel: initialViewModel)
    }
    
    func viewDidSelectFriend(with id: SteamID) {
        let profileViewController = ProfileModuleBuilder.build(steamID: id, output: nil)
        self.viewInput?.navigationController?.pushViewController(profileViewController, animated: true)
    }
}
