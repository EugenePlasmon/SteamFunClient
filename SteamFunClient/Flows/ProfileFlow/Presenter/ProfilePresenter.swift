//
//  ProfilePresenter.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class ProfilePresenter {
    
    weak var viewInput: (UIViewController & ProfileViewInput)?
    
    private let steamID: SteamID
    private lazy var dataLoader = ProfileDataLoader(steamID: steamID)
    
    private typealias LoadedData = (user: SteamUser, friends: [Friend], ownedGames: [Game])
    private var loadedData: LoadedData?
    
    init(steamID: SteamID) {
        self.steamID = steamID
    }
    
    private func viewModel(from data: LoadedData) -> ProfileViewModel {
        let (steamUser, friends, ownedGames) = data
        return ProfileViewModel(isHiddenProfile: steamUser.visibility != .public,
                                name: steamUser.personName,
                                realName: steamUser.realName,
                                avatarLink: steamUser.avatarLinks.full,
                                friendsCount: friends.count,
                                ownedGames: ownedGames)
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        log(.openFlow, "Profile, steamID = \(steamID)")
        self.viewInput?.showLoader()
        
        self.dataLoader.load { [weak self] result in
            guard let self = self else { return }
            result.onSuccess { loadedData in
                self.loadedData = loadedData
                self.viewInput?.showData(viewModel: loadedData >>> self.viewModel)
            }.onFailure {
                // TODO:
                log($0)
            }
        }
    }
    
    func viewDidTapFriends() {
        // TODO: routing
        guard let loadedData = self.loadedData else { return }
        let friendsViewController = FriendsModuleBuilder.build(friends: loadedData.friends, ofUser: loadedData.user)
        self.viewInput?.navigationController?.pushViewController(friendsViewController, animated: true)
    }
    
    func viewDidTapLogout() {
        try? Steam.SteamIDCaretaker.clear()
        // TODO:
        (UIApplication.shared.delegate as! AppDelegate).appLauncher.start()
    }
    
    func viewDidTapDota() {
        guard let loadedData = self.loadedData else { return }
        let dotaViewController = Dota2ModuleBuilder.build(steamUser: loadedData.user)
        self.viewInput?.navigationController?.pushViewController(dotaViewController, animated: true)
    }
    
    func viewDidTapGame(_ game: Game) {
        let viewController = GameAchievementsModuleBuilder.build(game: game, steamID: steamID)
        self.viewInput?.navigationController?.pushViewController(viewController, animated: true)
    }
}
