//
//  Dota2ShortStatsViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2ShortStatsViewController: UIViewController {
    
    let viewModel: Dota2ViewModel.ShortStats
    
    var onMoreTap: (() -> Void)? {
        didSet {
            moreLabel.onTap = onMoreTap
        }
    }
    
    // MARK: - Views
    
    private let titleLabel = UILabel(text: "Статистика в Dota 2",
                                     color: FeatureColor.Dota2ShortStats.title,
                                     font: .kerrigan)
    
    private let backgroundView = UIView(color: FeatureColor.Dota2ShortStats.background)
    
    private let moreLabel = ArrowedLabel(text: "Подробнее", color: FeatureColor.Dota2ShortStats.moreButton)
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var winrateView = Dota2ShortStatView(
        contents: .title("\(viewModel.averageWinrate)", subtitle: Constants.winrateSubtitle)
    )
    private lazy var matchDurationView = Dota2ShortStatView(
        contents: .title(viewModel.averageMatchDuration.hoursAndMinutes, subtitle: Constants.matchDurationSubtitle)
    )
    private lazy var favoriteTeamView = Dota2ShortStatView(
        contents: .image(viewModel.favoriteTeam.logoName >>- { UIImage(named: $0) },
                         rounded: false,
                         subtitle: Constants.favoriteTeamSubtitle)
    )
    private lazy var favoriteHeroView: Dota2ShortStatView = {
        let image = viewModel.favoriteHeroID
            >>- { Dota2Hero(id: $0)?.iconName }
            >>- { UIImage(named: $0) }
        return Dota2ShortStatView(
            contents: .image(image,
                             rounded: true,
                             subtitle: Constants.favoriteHeroSubtitle)
        )
    }()
    
    private struct Constants {
        static let winrateSubtitle = "%\(nbsp)побед за\(nbsp)все\(nbsp)время"
        static let matchDurationSubtitle = "среднее время матча"
        static let favoriteTeamSubtitle = "любимая сторона"
        static let favoriteHeroSubtitle = "любимый герой"
    }
    
    // MARK: - Init
    
    init(viewModel: Dota2ViewModel.ShortStats) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = .clear
        view.addSubview(titleLabel)
        view.addSubview(backgroundView)
        backgroundView.addSubview(statsStackView)
        backgroundView.addSubview(moreLabel)
        
        statsStackView.addArrangedSubview(favoriteHeroView)
        statsStackView.addArrangedSubview(favoriteTeamView)
        statsStackView.addArrangedSubview(winrateView)
        statsStackView.addArrangedSubview(matchDurationView)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24.0)
        }
        backgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            $0.left.right.equalToSuperview().inset(12.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(105.0)
        }
        statsStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.0)
            $0.left.right.equalToSuperview()
        }
        
        moreLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12.0)
            $0.right.equalToSuperview().inset(18.0)
        }
    }
}
