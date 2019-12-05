//
//  GameAchievementsHeaderView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class GameAchievementsHeaderView: ExpandableNavbar.ContentView {
    
    var imageUrl: String? {
        didSet {
            imageUrl
                >>- { URL(string: $0) }
                >>- { imageView.kf.setImage(with: $0) }
        }
    }
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var progress: GameAchievementsViewModel.Percents = 0.0 {
        didSet {
            progressView.progress = Float(progress / 100.0)
            progressPercentsLabel.text = "\(progress) %"
        }
    }
    
    private let imageView = UIImageView(contentMode: .scaleAspectFill)
    private let titleLabel = UILabel(color: FeatureColor.Achievements.gameName, font: .abathur, numberOfLines: 2)
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = FeatureColor.Achievements.playerProgress
        progressView.trackTintColor = FeatureColor.Achievements.playerProgressBackground
        return progressView
    }()
    private let progressPercentsLabel = UILabel(color: FeatureColor.Achievements.playerProgress, font: .niadra)
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .clear
        
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(progressView)
        addSubview(progressPercentsLabel)
        
        self.snp.makeConstraints {
            $0.height.equalTo(88.0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.0)
            $0.left.equalToSuperview().offset(16.0)
            $0.width.equalTo(92.0)
            $0.height.equalTo(35.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12.0)
            $0.left.equalTo(imageView.snp.right).offset(12.0)
            $0.right.equalToSuperview().offset(-12.0)
        }
        
        progressView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-8.0)
            $0.left.right.equalToSuperview().inset(16.0)
        }
        
        progressPercentsLabel.snp.makeConstraints {
            $0.bottom.equalTo(progressView.snp.top).offset(-2.0)
            $0.right.equalTo(progressView.snp.right)
        }
    }
}
