//
//  ProfileNavbarHeaderContentView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

final class ProfileNavbarHeaderContentView: UIView {
    
    var avatarUrl: String? {
        didSet {
            avatarUrl
                >>- { URL(string: $0) }
                >>- { avatar.kf.setImage(with: $0) }
        }
    }
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    // MARK: - Views
    
    private let avatar: UIImageView = {
        let avatar = UIImageView()
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = Constants.avatarLinearSize / 2
        avatar.layer.borderColor = UIColor.selendis.cgColor
        avatar.layer.borderWidth = 1.0
        return avatar
    }()
    
    private let titleLabel = UILabel(color: FeatureColor.Profile.name,
                                     font: .stukov)
    
    private struct Constants {
        static let avatarLinearSize: CGFloat = 30.0
    }
    
    // MARK: - Init
    
    init() {
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
        addSubview(titleLabel)
        
        avatar.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.width.height.equalTo(Constants.avatarLinearSize)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(avatar)
            $0.left.equalTo(avatar.snp.right).offset(10.0)
            $0.right.equalToSuperview()
        }
    }
}
