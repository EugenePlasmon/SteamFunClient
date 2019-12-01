//
//  RecentActivityGameCell.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class RecentActivityGameCell: UITableViewCell {
    
    static let reuseIdentifier = "RecentActivityGameCellReuseIdentifier"
    
    var imageUrl: String? {
        didSet {
            imageUrl
                >>- { URL(string: $0) }
                >>- { gameImageView.kf.setImage(with: $0) }
        }
    }
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var playtime: String? {
        get { playtimeLabel.text }
        set { playtimeLabel.text = newValue }
    }
    
    var playtimeLastTwoWeeks: String? {
        get { playtimeLastTwoWeeksLabel.text }
        set { playtimeLastTwoWeeksLabel.text = newValue }
    }
    
    // MARK: - Views
    
    private let containerView = UIView()
    private let gameImageView = UIImageView(contentMode: .scaleAspectFill)
    private let labelsContainerView = UIView()
    private let titleLabel = UILabel(color: FeatureColor.Profile.gameName,
                                     font: .abathur,
                                     numberOfLines: 0,
                                     compressionResistancePriorityY: .required)
    private let playtimeLabel = UILabel(color: FeatureColor.Profile.gamePlaytime,
                                        font: .niadra,
                                        numberOfLines: 0,
                                        compressionResistancePriorityY: .required)
    private let playtimeLastTwoWeeksLabel = UILabel(color: FeatureColor.Profile.gamePlaytime,
                                                    font: .niadra,
                                                    numberOfLines: 0,
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
        containerView.backgroundColor = FeatureColor.RecentActivity.gameCell
        
        contentView.addSubview(containerView)
        containerView.addSubview(gameImageView)
        containerView.addSubview(labelsContainerView)
        labelsContainerView.addSubview(titleLabel)
        labelsContainerView.addSubview(playtimeLabel)
        labelsContainerView.addSubview(playtimeLastTwoWeeksLabel)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().offset(-8.0)
        }
        
        gameImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8.0)
            $0.width.equalTo(92.0)
            $0.height.equalTo(35.0)
        }
        
        labelsContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.0)
            $0.bottom.equalToSuperview().offset(-12.0)
            $0.left.equalTo(gameImageView.snp.right).offset(8.0)
            $0.right.equalToSuperview().offset(-40.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        playtimeLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            $0.left.right.equalToSuperview()
        }
        playtimeLastTwoWeeksLabel.snp.makeConstraints {
            $0.top.equalTo(playtimeLabel.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
    }
}
