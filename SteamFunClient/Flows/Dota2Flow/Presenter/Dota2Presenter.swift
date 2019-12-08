//
//  Dota2Presenter.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2Presenter {
    
    // MARK: - Internal properties
    
    weak var viewInput: (UIViewController & Dota2ViewInput)?
    
    // MARK: - Private properties
    
    private let steamUser: SteamUser
    private let matchesRequestManager: Dota2MatchesRequestManager
    
    private var matches: [MatchDetails] = []
    
    // MARK: - Init
    
    init(steamUser: SteamUser, matchesRequestManager: Dota2MatchesRequestManager) {
        self.steamUser = steamUser
        self.matchesRequestManager = matchesRequestManager
    }
    
    // MARK: - Data obtaining
    
    private func loadData(success: @escaping () -> Void,
                          failure: @escaping (Error) -> Void,
                          onProgress: @escaping (Dota2MatchesRequestManager.LoadProgress) -> Void) {
        onProgress(matchesRequestManager.loadProgress)
        
        matchesRequestManager.onLoadProgressChange = onProgress
        matchesRequestManager.completion = { [weak self] result in
            guard let self = self else {
                success()
                return
            }
            result.onSuccess { userMatches in
                self.matches = userMatches.matches
                success()
            }.onFailure {
                log($0)
                failure($0)
            }
        }
        matchesRequestManager.getUserMatches()
    }
    
    // MARK: - View model creation
    
    private func createViewModel() -> Dota2ViewModel {
        return Dota2ViewModel(shortStats: calculateShortStats(),
                              navbar: navbarViewModel(),
                              matches: matches.compactMap(viewModelMatch))
    }
    
    private func calculateShortStats() -> Dota2ViewModel.ShortStats {
        var sumDuration: MatchDetails.Seconds = 0
        var wins = 0
        var playsForTeam: [Dota2Team: Int] = [.radiant: 0, .dire: 0]
        typealias HeroID = Int
        typealias MatchesCount = Int
        var matchesCountForHeroID: [HeroID: MatchesCount] = [:]
        for match in matches {
            sumDuration += match.duration
            wins += match.isUserWinner(steamID: steamUser.id) == true ? 1 : 0
            if let team = match.teamOfUser(steamID: steamUser.id) {
                playsForTeam[team]! += 1
            }
            if let heroID = match.heroIDOfUser(steamID: steamUser.id) {
                if let matchesCountForCurrentHeroID = matchesCountForHeroID[heroID] {
                    matchesCountForHeroID[heroID] = matchesCountForCurrentHeroID + 1
                } else {
                    matchesCountForHeroID[heroID] = 1
                }
            }
        }
        
        let matchesCount = matches.count
        let winrate = Double(wins) / Double(matchesCount) * 100.0
        let roundedWinrate = round(winrate * 10) / 10.0
        let averageDuration: Game.Minutes = (sumDuration / matchesCount) / 60
        let team: Dota2Team
        if playsForTeam[.radiant] == playsForTeam[.dire] {
            /// Чтобы не было рандома
            team = .radiant
        } else {
            team = playsForTeam.max { $0.value < $1.value }!.key
        }
        let heroID = matchesCountForHeroID.max { $0.value < $1.value }?.key
        
        return Dota2ViewModel.ShortStats(averageWinrate: roundedWinrate,
                                         averageMatchDuration: averageDuration,
                                         favoriteTeam: team,
                                         favoriteHeroID: heroID)
    }
    
    private func viewModelMatch(from match: MatchDetails) -> Dota2ViewModel.Match? {
        guard let currentPlayer = match.players.first(where: { $0.accountID == Int64(self.steamUser.id.to32) })
            , let hero = Dota2Hero(id: currentPlayer.heroID) else {
                return nil
        }
        let team = currentPlayer.slot.team
        let isWin = match.winner == team
        return Dota2ViewModel.Match(hero: hero, team: team, isWin: isWin, date: match.start)
    }
    
    private func navbarViewModel() -> Dota2ViewModel.Navbar {
        return .init(title: steamUser.personName, iconUrl: steamUser.avatarLinks.full)
    }
    
    // MARK: - UI Presenting
    
    private func presentError(_ error: Error) {
        let errorMessage: String
        switch error {
        case Steam.Error.userHasntAllowed:
            errorMessage = "История матчей скрыта настройками приватности"
        default:
            errorMessage = "Произошла ошибка получения данных. Попробуйте позже"
        }
        self.viewInput?.showError(message: errorMessage, navbarModel: self.navbarViewModel())
    }
}

// MARK: - Dota2ViewOutput

extension Dota2Presenter: Dota2ViewOutput {
    
    func viewDidLoad() {
        log(.openFlow, "Dota 2")
        viewInput?.showLoader()
        loadData(
            success: { [weak self] in
                guard let self = self else { return }
                self.viewInput?.showData(viewModel: self.createViewModel())
            }, failure: { [weak self] error in
                self?.presentError(error)
            }, onProgress: { [weak self] progress in
                self?.viewInput?.updateLoadingProgress(value: progress.progressValue)
        })
    }
    
    func viewDidTapMoreStats() {
        let viewController = Dota2StatsModuleBuilder.build(steamUser: steamUser, matches: matches)
        viewInput?.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - LoadProgress + ProgressValue

private extension Dota2MatchesRequestManager.LoadProgress {
    
    var progressValue: Float {
        let fullMatchHistoryObtainedValue: Float = 0.2
        switch self {
        case .notStarted:
            return 0
        case .fetchedFromDatabase:
            return 0.1
        case .fullMatchHistoryObtained:
            return fullMatchHistoryObtainedValue
        case .matchDetailsRequesting(let obtainedCount, let totalCount):
            let requestingProgress = Float(obtainedCount) / Float(totalCount)
            return fullMatchHistoryObtainedValue + (1 - fullMatchHistoryObtainedValue) * requestingProgress
        case .finished:
            return 1
        }
    }
}
