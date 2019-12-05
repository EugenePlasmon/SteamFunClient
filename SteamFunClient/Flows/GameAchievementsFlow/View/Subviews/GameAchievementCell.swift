//
//  GameAchievementCell.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class GameAchievementCell: UITableViewCell {
    
    static let reuseIdentifier = "GameAchievementCellReuseIdentifier"
    
    var imageUrl: String? {
        didSet {
            imageUrl
                >>- { URL(string: $0) }
                >>- { achievementImageView.kf.setImage(with: $0) }
        }
    }
    
    var name: String? {
        get { nameLabel.text }
        set { nameLabel.text = newValue }
    }
    
    var globalPercentage: Double? {
        didSet {
            guard let globalPercentage = globalPercentage else {
                percentageLabel.text = nil
                return
            }
            let roundedPercentage = round(globalPercentage * 10.0) / 10.0
            percentageLabel.text = rarityText(from: globalPercentage) + " \(roundedPercentage) %"
        }
    }
    
    var achievementDescription: String? {
        get { descriptionLabel.text }
        set { descriptionLabel.text = newValue }
    }
    
    private func rarityText(from percentage: Double) -> String {
        switch percentage {
        case 0...5: return "Крайне редкий"
        case 5...10: return "Очень редкий"
        case 10...50: return "Редкий"
        case 50...100: return "Обычный"
        default: return ""
        }
    }
    
    // MARK: - Views
    
    private let containerView = UIView()
    private let achievementImageView = UIImageView(contentMode: .scaleAspectFill)
    private let textsContainerView = UIView()
    private let nameLabel = UILabel(color: FeatureColor.Achievements.achievementName,
                                    font: .brakk,
                                    numberOfLines: 1,
                                    compressionResistancePriorityY: .required)
    private let percentageLabel = UILabel(color: FeatureColor.Achievements.achievementPercentage,
                                          font: .niadra,
                                          numberOfLines: 1,
                                          compressionResistancePriorityY: .required)
    private let descriptionLabel = UILabel(color: FeatureColor.Achievements.achievementDescription,
                                          font: .niadra,
                                          numberOfLines: 1,
                                          compressionResistancePriorityY: .required)
    
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
        containerView.backgroundColor = FeatureColor.Achievements.achievementCell
        
        contentView.addSubview(containerView)
        containerView.addSubview(achievementImageView)
        containerView.addSubview(textsContainerView)
        textsContainerView.addSubview(nameLabel)
        textsContainerView.addSubview(percentageLabel)
        textsContainerView.addSubview(descriptionLabel)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().offset(-8.0)
        }
        
        achievementImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8.0)
            $0.left.equalToSuperview().offset(8.0)
            $0.width.equalTo(48.0)
            $0.height.equalTo(48.0)
        }
        
        textsContainerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(achievementImageView.snp.right).offset(12.0)
            $0.right.equalToSuperview().offset(-12.0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        percentageLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(4.0)
            $0.left.right.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(percentageLabel.snp.bottom).offset(4.0)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
