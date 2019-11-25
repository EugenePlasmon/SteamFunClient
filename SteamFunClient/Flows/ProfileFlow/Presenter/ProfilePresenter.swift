//
//  ProfilePresenter.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class ProfilePresenter {
    
    weak var viewInput: ProfileViewInput?
    
    private let steamID: SteamID
    private lazy var dataLoader = ProfileDataLoader(steamID: steamID)
    
    init(steamID: SteamID) {
        self.steamID = steamID
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        self.viewInput?.showLoader()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.dataLoader.load { [weak self] result in
                guard let self = self else { return }
                result.onSuccess { steamUser, friends, ownedGames in
                    let viewModel = ProfileViewModel(name: steamUser.personName, realName: steamUser.realName, avatarLink: steamUser.avatarLinks.full, friendsCount: friends.count, ownedGames: ownedGames)
                    self.viewInput?.showData(viewModel: viewModel)
                }.onFailure {
                    // TODO:
                    print($0)
                }
            }
        }
    }
    
    func viewDidTapLogout() {
        try? Steam.SteamIDCaretaker.clear()
        // TODO:
        (UIApplication.shared.delegate as! AppDelegate).appLauncher.start()
    }
}
