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
    
    init(steamID: SteamID) {
        self.steamID = steamID
    }
}

extension ProfilePresenter: ProfileViewOutput {
    
    func viewDidLoad() {
        Steam.getProfileInfo(for: steamID) { [weak self] result in
            result.onSuccess {
                self?.viewInput?.show(name: $0.personName, realName: $0.realName, avatarLink: $0.avatarLinks.full)
            }.onFailure {
                // TODO:
                print($0)
            }
        }
        Steam.getOwnedGames(for: steamID) { [weak self] result in
            result.onSuccess {
                self?.viewInput?.show(games: $0)
            }.onFailure {
                // TODO:
                print($0)
            }
        }
    }
    
    func viewDidTapLogout() {
        try? Steam.SteamIDCaretaker.clear()
        // TODO:
        (UIApplication.shared.delegate as! AppDelegate).appLauncher.start()
    }
}
