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
    
    private func loadData(then completion: @escaping ([SteamUser]) -> Void) {
        let dispatchGroup = DispatchGroup()
        var data: [SteamUser] = []
        
        for friend in friends {
            dispatchGroup.enter()
            Steam.getProfileInfo(for: friend.id) { result in
                result.onSuccess {
                    data.append($0)
                }.onFailure {
                    // TODO:
                    print($0)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(data)
        }
    }
    
    private func viewModel(from data: [SteamUser]) -> FriendsViewModel {
        let cells = data.compactMap {
            FriendsViewModel.Cell(steamID: $0.id, name: $0.personName, realName: $0.realName, avatarLink: $0.avatarLinks.full)
        }
        return FriendsViewModel(title: "Друзья " + user.personName,
                                avatarLink: user.avatarLinks.full,
                                cells: cells)
    }
}

extension FriendsPresenter: FriendsViewOutput {
    
    func viewDidLoad() {
        log(.openFlow, "Friends (of user steamID=\(user.id))")
        self.viewInput?.showLoader()
        loadData { [weak self] data in
            guard let self = self else { return }
            self.viewInput?.showData(viewModel: self.viewModel(from: data))
        }
    }
    
    func viewDidSelectFriend(with id: SteamID) {
        let profileViewController = ProfileModuleBuilder.build(steamID: id)
        self.viewInput?.navigationController?.pushViewController(profileViewController, animated: true)
    }
}
