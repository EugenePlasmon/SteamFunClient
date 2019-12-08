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
    weak var output: ProfileModuleOutput?
    
    private let steamID: SteamID
    private lazy var dataLoader = ProfileDataLoader(steamID: steamID)
    
    private typealias LoadedData = (user: SteamUser, friends: [Friend], ownedGames: [Game])
    private var loadedData: LoadedData?
    private var isCurrentProfile: Bool = false
    
    // MARK: - Init
    
    init(steamID: SteamID, output: ProfileModuleOutput?) {
        self.steamID = steamID
        self.output = output
    }
    
    // MARK: - ViewModel
    
    private func viewModel(from data: LoadedData) -> ProfileViewModel {
        let (steamUser, friends, ownedGames) = data
        return ProfileViewModel(isHiddenProfile: steamUser.visibility != .public,
                                showLogoutButton: isCurrentProfile,
                                name: steamUser.personName,
                                realName: steamUser.realName,
                                avatarLink: steamUser.avatarLinks.full,
                                friendsCount: friends.count,
                                ownedGames: ownedGames)
    }
    
    private func errorViewModel(error: Error) -> ProfileViewModel {
        return ProfileViewModel(isHiddenProfile: false,
                                showLogoutButton: false,
                                name: "Ошибка",
                                realName: error.localizedDescription,
                                avatarLink: nil,
                                friendsCount: 0,
                                ownedGames: [])
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        log(.openFlow, "Profile, steamID = \(steamID)")
        self.viewInput?.showLoader()
        
        self.isCurrentProfile = Steam.SteamIDCaretaker.steamID == steamID
        
        self.dataLoader.load { [weak self] result in
            guard let self = self else { return }
            result.onSuccess { loadedData in
                self.loadedData = loadedData
                self.viewInput?.showData(viewModel: loadedData >>> self.viewModel)
            }.onFailure {
                self.viewInput?.showData(viewModel: $0 >>> self.errorViewModel)
            }
        }
    }
    
    func viewDidTapFriends() {
        guard let loadedData = self.loadedData else { return }
        let friendsViewController = FriendsModuleBuilder.build(friends: loadedData.friends, ofUser: loadedData.user)
        self.viewInput?.navigationController?.pushViewController(friendsViewController, animated: true)
    }
    
    func viewDidTapLogout() {
        self.output?.profileDidLogout()
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
