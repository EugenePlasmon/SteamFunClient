//
//  GameAchievementsPresenter.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 05.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class GameAchievementsPresenter {
    
    // MARK: - Properties
    
    weak var viewInput: (UIViewController & GameAchievementsViewInput)?
    
    let game: Game
    let steamID: SteamID
    
    // MARK: - Private properties
    
    private var gameSchema: GameSchema?
    private var playerAchievements: PlayerGameAchievements?
    private var globalPercentages: GlobalAchievementPercentages?
    private var errors: [Error] = []
    
    // MARK: - Init
    
    init(game: Game, steamID: SteamID) {
        self.game = game
        self.steamID = steamID
    }
    
    // MARK: - Data loading
    
    private func loadData(then completion: @escaping (Result<GameAchievementsViewModel, Steam.Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        loadGameSchema { dispatchGroup.leave() }
        
        dispatchGroup.enter()
        loadPlayerAchievements { dispatchGroup.leave() }
        
        dispatchGroup.enter()
        loadGlobalAchievementPercentages { dispatchGroup.leave() }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.handleDataLoaded(then: completion)
        }
    }
    
    private func loadGameSchema(then completion: @escaping () -> Void) {
        Steam.getGameSchema(gameID: game.id) { [weak self] result in
            guard let self = self else {
                completion()
                return
            }
            result.onSuccess {
                self.gameSchema = $0
            }.onFailure {
                self.errors.append($0)
            }
            completion()
        }
    }
    
    private func loadPlayerAchievements(then completion: @escaping () -> Void) {
        Steam.getPlayerGameAchievements(steamID: steamID, gameID: game.id) { [weak self] result in
            guard let self = self else {
                completion()
                return
            }
            result.onSuccess {
                self.playerAchievements = $0
            }.onFailure {
                self.errors.append($0)
            }
            completion()
        }
    }
    
    private func loadGlobalAchievementPercentages(then completion: @escaping () -> Void) {
        Steam.getGlobalAchievementPercentages(gameID: game.id) { [weak self] result in
            guard let self = self else {
                completion()
                return
            }
            result.onSuccess {
                self.globalPercentages = $0
            }.onFailure {
                self.errors.append($0)
            }
            completion()
        }
    }
    
    private func handleDataLoaded(then completion: @escaping (Result<GameAchievementsViewModel, Steam.Error>) -> Void) {
        guard self.errors.isEmpty else {
            for error in self.errors {
                switch error {
                case Steam.Error.noGameStats:
                    completion(.failure(.noGameStats))
                    return
                default: break
                }
            }
            completion(.failure(.dataCorrupted))
            return
        }
        
        guard let gameSchema = self.gameSchema
            , let playerAchievements = self.playerAchievements
            , let globalPercentages = self.globalPercentages else {
                completion(.failure(.dataCorrupted))
                return
        }
        let viewModel = self.createViewModel(gameSchema: gameSchema,
                                             playerAchievements: playerAchievements,
                                             globalPercentages: globalPercentages)
        completion(.success(viewModel))
    }
    
    // MARK: - View model
    
    private struct CombinedAchievement {
        let gameAchievement: GameAchievement
        let playerAchievement: PlayerGameAchievements.Achievement
        let globalAchievement: GlobalAchievementPercentages.Achievement
    }
    
    private func combinedAchievements(gameSchema: GameSchema,
                                      playerAchievements: PlayerGameAchievements,
                                      globalPercentages: GlobalAchievementPercentages) -> [CombinedAchievement] {
        return gameSchema.availableGameStats.achievements.compactMap { gameAchievement in
            guard let playerAchievement = playerAchievements.achievements.first(where: { $0.apiName == gameAchievement.apiName })
                , let globalAchievement = globalPercentages.achievements.first(where: { $0.name == gameAchievement.apiName })
                else { return nil }
            return CombinedAchievement(gameAchievement: gameAchievement, playerAchievement: playerAchievement, globalAchievement: globalAchievement)
        }
    }
    
    private func createViewModel(gameSchema: GameSchema,
                                 playerAchievements: PlayerGameAchievements,
                                 globalPercentages: GlobalAchievementPercentages) -> GameAchievementsViewModel {
        let achievements = self.combinedAchievements(gameSchema: gameSchema,
                                                     playerAchievements: playerAchievements,
                                                     globalPercentages: globalPercentages)
        
        let achievedCount = achievements.reduce(0) { $0 + ($1.playerAchievement.achieved ? 1 : 0) }
        let totalAchievementsCount = achievements.count
        let playerProgress = round(100.0 * Double(achievedCount) / Double(totalAchievementsCount))
        let header = GameAchievementsViewModel.Header(gameName: game.name, gameLogoUrl: game.logoUrl, gameIconUrl: game.iconUrl, playerProgress: playerProgress)
        
        let cells: [GameAchievementsViewModel.Cell] = achievements
            .sorted { $0.playerAchievement.achieved && !$1.playerAchievement.achieved }
            .map {
                let unlocked = $0.playerAchievement.achieved
                let hidden = unlocked ? false : $0.gameAchievement.hidden
                let name = $0.gameAchievement.displayName
                let description = $0.gameAchievement.description
                let globalPercentage = $0.globalAchievement.percent
                let unlockDate = $0.playerAchievement.unlockDate
                let imageUrl = unlocked ? $0.gameAchievement.iconUrl : $0.gameAchievement.iconGrayUrl
                return GameAchievementsViewModel.Cell(hidden: hidden, name: name, description: description, globalPercentage: globalPercentage, unlocked: unlocked, unlockDate: unlockDate, imageUrl: imageUrl)
        }
        
        return GameAchievementsViewModel(header: header, cells: cells)
    }
}

// MARK: - GameAchievementsViewOutput

extension GameAchievementsPresenter: GameAchievementsViewOutput {
    
    func viewDidLoad() {
        viewInput?.showLoader()
        loadData { [weak self] result in
            guard let self = self else { return }
            result.onSuccess {
                self.viewInput?.showData(viewModel: $0)
            }.onFailure {
                log($0)
                let errorMessage: String
                switch $0 {
                case .noGameStats:
                    errorMessage = "Для данной игры отсутствует игровая статистика и достижения"
                default:
                    errorMessage = "Произошла ошибка получения данных. Попробуйте позже"
                }
                self.viewInput?.showError(message: errorMessage)
            }
        }
    }
}

