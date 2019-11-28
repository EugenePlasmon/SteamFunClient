//
//  ProfileDataLoader.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 27.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class ProfileDataLoader {
    
    let steamID: SteamID
    
    init(steamID: SteamID) {
        self.steamID = steamID
    }
    
    private struct LoadedData {
        var steamUser: SteamUser?
        var friends: [Friend]?
        var ownedGames: [OwnedGame]?
        var errors: [Error] = []
    }
    private var loadedData = LoadedData()
    
    func load(then completion: @escaping (Result<(SteamUser, [Friend], [OwnedGame]), Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getUser { dispatchGroup.leave() }
        
        dispatchGroup.enter()
        getFriends { dispatchGroup.leave() }
        
        dispatchGroup.enter()
        getOwnedGames { dispatchGroup.leave() }
        
        dispatchGroup.notify(queue: .main) {
            guard self.loadedData.errors.isEmpty else {
                // TODO:
                return
            }
            guard let steamUser = self.loadedData.steamUser
                , let friends = self.loadedData.friends
                , let ownedGames = self.loadedData.ownedGames else {
                    // TODO:
                    return
            }
            let data = (steamUser, friends, ownedGames)
            completion(.success(data))
        }
    }
    
    private func getUser(then completion: @escaping () -> Void) {
        Steam.getProfileInfo(for: steamID) { [weak self] result in
            result.onSuccess {
                self?.loadedData.steamUser = $0
            }.onFailure {
                log($0)
                self?.loadedData.errors.append($0)
            }
            completion()
        }
    }
    
    private func getFriends(then completion: @escaping () -> Void) {
        Steam.getFriends(for: steamID) { [weak self] result in
            result.onSuccess {
                self?.loadedData.friends = $0
            }.onFailure {
                log($0)
                self?.loadedData.errors.append($0)
            }
            completion()
        }
    }
    
    private func getOwnedGames(then completion: @escaping () -> Void) {
        Steam.getOwnedGames(for: steamID) { [weak self] result in
            result.onSuccess {
                self?.loadedData.ownedGames = $0
            }.onFailure {
                log($0)
                self?.loadedData.errors.append($0)
            }
            completion()
        }
    }
}
