//
//  FriendsListCell.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class FriendsListCell: UITableViewCell {
    
    static let reuseIdentifier = "FriendsListCellReuseIdentifier"
    
    var isLoading: Bool = false {
        didSet {
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
            [avatar, nameLabel, realNameLabel].forEach { $0.isHidden = isLoading }
        }
    }
    
    var avatarUrl: String? {
        didSet {
            avatarUrl
                >>- { URL(string: $0) }
                >>- { avatar.kf.setImage(with: $0) }
        }
    }
    
    var name: String? {
        get { nameLabel.text }
        set { nameLabel.text = newValue }
    }
    
    var realName: String? {
        get { realNameLabel.text }
        set { realNameLabel.text = newValue }
    }
    
    // MARK: - Views
    
    private let containerView = UIView()
    private let avatar = UIImageView(contentMode: .scaleAspectFit)
    private let avatarBar = UIView()
    private let textsContainerView = UIView()
    private let nameLabel = UILabel(color: FeatureColor.Friends.friendName,
                                     font: .abathur,
                                     numberOfLines: 0,
                                     compressionResistancePriorityY: .required)
    private let realNameLabel = UILabel(color: FeatureColor.Friends.friendRealName,
                                        font: .niadra,
                                        compressionResistancePriorityY: .required)
    private let activityIndicator = UIActivityIndicatorView()
    
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
        containerView.backgroundColor = FeatureColor.Friends.friendCell
        avatarBar.backgroundColor = FeatureColor.Friends.avatarBar
        
        contentView.addSubview(containerView)
        containerView.addSubview(avatar)
        containerView.addSubview(avatarBar)
        containerView.addSubview(textsContainerView)
        textsContainerView.addSubview(nameLabel)
        textsContainerView.addSubview(realNameLabel)
        containerView.addSubview(activityIndicator)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().offset(-8.0)
            $0.height.equalTo(60.0)
        }
        
        avatar.snp.makeConstraints {
            $0.top.bottom.left.equalToSuperview()
            $0.width.equalTo(avatar.snp.height)
        }
        
        avatarBar.snp.makeConstraints {
            $0.left.equalTo(avatar.snp.right)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(2.0)
        }
        
        textsContainerView.snp.makeConstraints {
            $0.left.equalTo(avatarBar.snp.right).offset(10.0)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-24.0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        realNameLabel.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
            $0.top.equalTo(nameLabel.snp.bottom).offset(4.0)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
