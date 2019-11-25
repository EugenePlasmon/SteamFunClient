//
//  OwnedGamesCell.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class OwnedGamesCell: UITableViewCell {
    
    static let reuseIdentifier = "OwnedGamesCellReuseIdentifier"
    
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
    
    // MARK: - Views
    
    private let containerView = UIView()
    private let gameImageView = UIImageView(contentMode: .scaleAspectFit)
    private let titleLabel = UILabel(color: FeatureColor.Profile.gameName,
                                     font: .abathur,
                                     numberOfLines: 0,
                                     compressionResistancePriorityY: .required)
    private let playtimeLabel = UILabel(color: FeatureColor.Profile.gamePlaytime,
                                        font: .niadra,
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
        containerView.backgroundColor = FeatureColor.Profile.gameCell
        
        contentView.addSubview(containerView)
        containerView.addSubview(gameImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(playtimeLabel)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(16.0)
            $0.right.equalToSuperview().offset(-16.0)
            $0.bottom.equalToSuperview().offset(-8.0)
        }
        
        gameImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.0)
            $0.bottom.lessThanOrEqualToSuperview().offset(-12.0)
            $0.left.equalToSuperview().offset(16.0)
            $0.width.equalTo(92.0)
            $0.height.equalTo(35.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.0)
            $0.left.equalTo(gameImageView.snp.right).offset(12.0)
            $0.right.equalToSuperview().offset(-12.0)
        }
        
        playtimeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-12.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            $0.bottom.equalToSuperview().offset(-6.0)
        }
    }
}
