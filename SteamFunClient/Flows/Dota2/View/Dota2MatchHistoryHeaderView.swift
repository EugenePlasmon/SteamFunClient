//
//  Dota2MatchHistoryHeaderView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2MatchHistoryHeaderView: UIView {
    
    private var textColor: UIColor { FeatureColor.Dota2MatchHistory.headerTexts }
    
    private let blurView = BlurView(color: FeatureColor.Dota2.background)
    private lazy var titleLabel = UILabel(text: "История матчей", color: textColor, font: .kerrigan)
    private lazy var heroLabel = UILabel(text: "Герой", color: textColor, font: .zurvan, textAlignment: .center)
    private lazy var teamLabel = UILabel(text: "Сторона", color: textColor, font: .zurvan, textAlignment: .center)
    private lazy var winLoseLabel = UILabel(text: "Победа?", color: textColor, font: .zurvan, textAlignment: .center)
    private lazy var dateLabel = UILabel(text: "Дата", color: textColor, font: .zurvan, textAlignment: .center)
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .bottom
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        return stackView
    }()
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(blurView)
        addSubview(titleLabel)
        addSubview(stackView)
        
        [heroLabel, teamLabel, winLoseLabel, dateLabel].forEach(stackView.addArrangedSubview)
        
        blurView.snp.pinToAllSuperviewEdges()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.0)
            $0.left.right.equalToSuperview().inset(24.0)
        }
        
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            $0.bottom.equalToSuperview().offset(-6.0)
        }
    }
}
