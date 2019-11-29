//
//  ProfileNavbarContentView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final class ProfileNavbarContentView: ExpandableNavbarContentView {
    
    let viewModel: ProfileViewModel
    
    var onActionButtonTap: ProfileActionButton.OnTapClosure? {
        didSet {
            friendsActionButton.onTap = onActionButtonTap
        }
    }
    
    // MARK: - Views
    
    private lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 8.0
        avatar.layer.borderColor = UIColor.selendis.cgColor
        avatar.layer.borderWidth = 1.0
        viewModel.avatarLink
            >>- { URL(string: $0) }
            >>- { avatar.kf.setImage(with: $0) }
        return avatar
    }()
    
    private lazy var nameLabel = UILabel(text: viewModel.name,
                                         color: FeatureColor.Profile.name,
                                         font: .kerrigan)
    private lazy var realNameLabel = UILabel(text: viewModel.realName,
                                             color: FeatureColor.Profile.realName,
                                             font: .abathur)
    
    private let actionButtonsStackView = UIStackView()
    private lazy var friendsActionButton: ProfileActionButton = {
        let type: ProfileActionButton.`Type` = self.viewModel.friendsVisible
            ? .friends(count: viewModel.friendsCount)
            : .hiddenFriends
        return ProfileActionButton(type: type)
    }()
//    private let achievementsActionButton = ProfileActionButton(type: .achievements(count: 666))
//    private let moreActionButton = ProfileActionButton(type: .more)
    
    // MARK: - Init
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(realNameLabel)
        addSubview(actionButtonsStackView)
        
        actionButtonsStackView.axis = .horizontal
        actionButtonsStackView.distribution = .fillEqually
        actionButtonsStackView.addArrangedSubview(friendsActionButton)
//        actionButtonsStackView.addArrangedSubview(achievementsActionButton)
//        actionButtonsStackView.addArrangedSubview(moreActionButton)
        
        avatar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(88.0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatar.snp.bottom).offset(12.0)
            $0.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview().offset(20.0)
            $0.right.lessThanOrEqualToSuperview().offset(-20.0)
        }
        
        realNameLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(12.0)
            $0.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview().offset(20.0)
            $0.right.lessThanOrEqualToSuperview().offset(-20.0)
        }
        
        actionButtonsStackView.snp.makeConstraints {
            $0.top.equalTo(realNameLabel.snp.bottom).offset(40.0)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-28.0)
        }
    }
}
