//
//  Dota2MatchCell.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2MatchCell: UITableViewCell {
    
    static let reuseIdentifier = "Dota2MatchCellReuseIdentifier"
    
    // MARK: - Properties
    
    var hero: Dota2Hero? {
        didSet {
            heroView.image = hero?.iconName >>- { UIImage(named: $0) }
            heroView.text = hero?.name
        }
    }
    
    var team: Dota2Team? {
        didSet {
            teamView.image = team?.logoName >>- { UIImage(named: $0) }
            teamView.text = team?.rawValue.capitalized
        }
    }
    
    var isWin: Bool? {
        didSet {
            guard let isWin = isWin else {
                winLoseLabel.text = nil
                return
            }
            winLoseLabel.text = isWin ? "Да" : "Нет"
            winLoseLabel.textColor = isWin
                ? FeatureColor.Dota2MatchHistory.Cell.win
                : FeatureColor.Dota2MatchHistory.Cell.lose
        }
    }
    
    var date: Date? {
        didSet {
            dateLabel.text = date >>- Dota2MatchCell.dateFormatter.string
        }
    }
    
    // MARK: - Views
    
    private let containerView = UIView()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 4.0
        return stackView
    }()
    private let heroView = ImageWithSubtextView(textColor: FeatureColor.Dota2MatchHistory.Cell.heroName,
                                                isImageRounded: true)
    private let teamView = ImageWithSubtextView(textColor: FeatureColor.Dota2MatchHistory.Cell.team,
                                                isImageRounded: false)
    private let winLoseLabel = UILabel(font: .nafash,
                                       textAlignment: .center)
    private let dateLabel = UILabel(color: FeatureColor.Dota2MatchHistory.Cell.date,
                                    font: .zurvan,
                                    numberOfLines: 2,
                                    textAlignment: .center)
    
    // MARK: - DateFormatter
    
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter
    }()
    
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
        contentView.backgroundColor = .clear
        containerView.backgroundColor = FeatureColor.Dota2MatchHistory.Cell.background
        
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(heroView)
        stackView.addArrangedSubview(teamView)
        stackView.addArrangedSubview(winLoseLabel)
        stackView.addArrangedSubview(dateLabel)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12.0)
            $0.bottom.equalToSuperview().offset(-12.0)
            $0.height.equalTo(70.0)
        }
        
        stackView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(4.0)
            $0.top.bottom.equalToSuperview()
        }
    }
}
