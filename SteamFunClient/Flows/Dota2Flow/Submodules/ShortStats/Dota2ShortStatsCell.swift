//
//  Dota2ShortStatsCell.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2ShortStatsCell: UITableViewCell {
    
    static let reuseIdentifier = "Dota2ShortStatsCellReuseIdentifier"
    
    var viewModel: Dota2ViewModel.ShortStats? {
        didSet {
            statsStackView.arrangedSubviews.forEach {
                statsStackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            guard let viewModel = viewModel else {
                statsStackView.isHidden = true
                return
            }
            statsStackView.isHidden = false
            statsStackView.addArrangedSubview(createFavoriteHeroView(viewModel: viewModel))
            statsStackView.addArrangedSubview(createFavoriteTeamView(viewModel: viewModel))
            statsStackView.addArrangedSubview(createWinrateView(viewModel: viewModel))
            statsStackView.addArrangedSubview(createMatchDurationView(viewModel: viewModel))
        }
    }
    
    // MARK: - Views
    
    private let titleLabel = UILabel(text: "Статистика в Dota 2",
                                     color: FeatureColor.Dota2ShortStats.title,
                                     font: .kerrigan)
    
    private let viewWithBackgroundFill = UIView(color: FeatureColor.Dota2ShortStats.background)
    
    private let moreLabel: ArrowedLabel = {
        let label = ArrowedLabel(text: "Подробнее", color: FeatureColor.Dota2ShortStats.moreButton)
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private func createWinrateView(viewModel: Dota2ViewModel.ShortStats) -> Dota2ShortStatView {
        return Dota2ShortStatView(
            contents: .title("\(viewModel.averageWinrate)", subtitle: Constants.winrateSubtitle)
        )
    }
    
    private func createMatchDurationView(viewModel: Dota2ViewModel.ShortStats) -> Dota2ShortStatView {
        return Dota2ShortStatView(
            contents: .title(viewModel.averageMatchDuration.hoursAndMinutes, subtitle: Constants.matchDurationSubtitle)
        )
    }
    
    private func createFavoriteTeamView(viewModel: Dota2ViewModel.ShortStats) -> Dota2ShortStatView {
        return Dota2ShortStatView(
            contents: .image(viewModel.favoriteTeam.logoName >>- { UIImage(named: $0) },
                             rounded: false,
                             subtitle: Constants.favoriteTeamSubtitle)
        )
    }
    private func createFavoriteHeroView(viewModel: Dota2ViewModel.ShortStats) -> Dota2ShortStatView {
        let image = viewModel.favoriteHeroID
            >>- { Dota2Hero(id: $0)?.iconName }
            >>- { UIImage(named: $0) }
        return Dota2ShortStatView(
            contents: .image(image, rounded: true, subtitle: Constants.favoriteHeroSubtitle)
        )
    }
    
    private struct Constants {
        static let winrateSubtitle = "%\(nbsp)побед за\(nbsp)все\(nbsp)время"
        static let matchDurationSubtitle = "среднее время матча"
        static let favoriteTeamSubtitle = "любимая сторона"
        static let favoriteHeroSubtitle = "любимый герой"
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(viewWithBackgroundFill)
        viewWithBackgroundFill.addSubview(statsStackView)
        viewWithBackgroundFill.addSubview(moreLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(24.0)
        }
        viewWithBackgroundFill.snp.makeConstraints {
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
