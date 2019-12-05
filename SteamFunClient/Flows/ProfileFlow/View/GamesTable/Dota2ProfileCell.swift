//
//  Dota2ProfileCell.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 30.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2ProfileCell: UITableViewCell {
    
    static let reuseIdentifier = "Dota2CellReuseIdentifier"
    
    var backgroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var subtitle: String? {
        get { subtitleLabel.text }
        set { subtitleLabel.text = newValue }
    }
    
    // MARK: - Views
    
    private let containerView = UIView()
    private let backgroundImageView = UIImageView(contentMode: .scaleAspectFill)
    private let backtroundOverlayView = UIView()
    private let titleLabel = UILabel(color: FeatureColor.Profile.dota2Title,
                                     font: .izsha,
                                     numberOfLines: 0,
                                     compressionResistancePriorityY: .required)
    private let subtitleLabel = UILabel(color: FeatureColor.Profile.dota2Subtitle,
                                        font: .zagara,
                                        compressionResistancePriorityY: .required)
    private let arrow = ArrowView(direction: .right, color: .artanis, insets: .init(top: 4, left: 4, bottom: 4, right: 4))
    
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
        backgroundImageView.clipsToBounds = true
        backtroundOverlayView.backgroundColor = UIColor.alarak.withAlphaComponent(0.36)
        containerView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(backtroundOverlayView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(arrow)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().offset(-8.0)
            $0.height.equalTo(59.0)
        }
        
        backgroundImageView.snp.pinToAllSuperviewEdges()
        backtroundOverlayView.snp.pinToAllSuperviewEdges()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(11.0)
            $0.left.equalToSuperview().offset(12.0)
            $0.right.equalToSuperview().offset(-32.0)
        }
        
        subtitleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12.0)
            $0.right.equalToSuperview().offset(-32.0)
            $0.top.equalTo(titleLabel.snp.bottom)
        }
        
        arrow.snp.makeConstraints {
            $0.width.equalTo(16.0)
            $0.height.equalTo(28.0)
            $0.right.equalToSuperview().offset(-12.0)
            $0.centerY.equalToSuperview()
        }
    }
}
