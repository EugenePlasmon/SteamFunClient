//
//  Dota2StatsTopHeroesViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2StatsTopHeroesViewController: UIViewController {
    
    // MARK: - Models
    
    let steamUser: SteamUser
    let matches: [MatchDetails]
    
    private var columns: [Histogram.Column] = []
    
    private let dota2TopHeroesHistogramConfig
        = Histogram.Config(valueFont: .zurvan,
                           valueColor: FeatureColor.Dota2Stats.TopHeroes.columnValue,
                           columnColor: FeatureColor.Dota2Stats.TopHeroes.columnBackground,
                           columnWidth: 40.0,
                           imageRounded: true,
                           insets: UIEdgeInsets(top: 0, left: 12.0, bottom: 0, right: 12.0))
    
    // MARK: - Views
    
    private let titleLabel = UILabel(text: "% побед", color: FeatureColor.Dota2Stats.TopHeroes.title, font: .ryloth)
    private var histogram: Histogram?
    
    // MARK: - Init
    
    init(steamUser: SteamUser, matches: [MatchDetails]) {
        self.steamUser = steamUser
        self.matches = matches
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareModel()
        configureUI()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        let histogram = Histogram(config: dota2TopHeroesHistogramConfig, columns: columns)
        self.histogram = histogram
        
        view.addSubview(titleLabel)
        addChild(histogram)
        view.addSubview(histogram.view)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(6.0)
            $0.left.right.equalToSuperview().inset(12.0)
        }
        
        histogram.view.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6.0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(200.0)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Calculations
    
    private struct PreparedModel {
        let hero: Dota2Hero
        let winrate: Double
    }
    
    private func prepareModel() {
        var models: [Int: (wins: Int, totalCount: Int)] = [:]
        for match in matches {
            guard let heroID = match.heroIDOfUser(steamID: steamUser.id)
                , let isWin = match.isUserWinner(steamID: steamUser.id) else {
                    continue
            }
            if let existingHeroModel = models[heroID] {
                models[heroID] = (existingHeroModel.wins + (isWin ? 1 : 0), existingHeroModel.totalCount + 1)
            } else {
                models[heroID] = (isWin ? 1 : 0, 1)
            }
        }
        let preparedModels
            = models.compactMap { model -> PreparedModel? in
                guard let hero = Dota2Hero(id: model.key) else { return nil }
                let winrate = Double(model.value.wins) / Double(model.value.totalCount)
                return PreparedModel(hero: hero, winrate: winrate)
            }
            .sorted { $0.winrate > $1.winrate }
        guard let maxWinrate = preparedModels.first?.winrate else { return }
        let minY: Double = 0.0
        var maxY = maxWinrate * 1.2
        if maxY == 0.0 { maxY = 1.0 }
        
        let columns: [Histogram.Column] = preparedModels.map {
            let value = CGFloat($0.winrate / (maxY - minY))
            let percents = $0.winrate * 100.0
            let roundedPercents = round(10.0 * percents) / 10.0
            let text = "\(roundedPercents)"
            return Histogram.Column(value: value, text: text, imageName: $0.hero.iconName)
        }
        self.columns = columns
    }
}
