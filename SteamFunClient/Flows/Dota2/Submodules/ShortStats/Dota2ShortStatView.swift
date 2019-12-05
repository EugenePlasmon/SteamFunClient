//
//  Dota2ShortStatView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2ShortStatView: UIView {
    
    enum Contents {
        case title(_ title: String, subtitle: String)
        case image(_ image: UIImage?, rounded: Bool, subtitle: String)
    }
    
    let contents: Contents
    
    private lazy var titleLabel = UILabel(color: FeatureColor.Dota2ShortStats.statTitle,
                                          font: .izsha,
                                          textAlignment: .center,
                                          compressionResistancePriorityY: .required)
    private lazy var subtitleLabel = UILabel(color: FeatureColor.Dota2ShortStats.statSubtitle,
                                             font: .niadra,
                                             numberOfLines: 0,
                                             textAlignment: .center,
                                             compressionResistancePriorityY: .required)
    private lazy var imageView = UIImageView(contentMode: .scaleAspectFill, clipsToBounds: true)
    
    // MARK: - Init
    
    init(contents: Contents) {
        self.contents = contents
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        switch self.contents {
        case .image(_, let rounded, _):
            imageView.layer.cornerRadius = rounded ? imageView.bounds.width / 2 : 0.0
        case .title:
            break
        }
    }
    
    // MARK: - UI
    
    private func configureUI() {
        switch contents {
        case .title(let title, let subtitle):
            addTitleAndSubtitle(title, subtitle)
        case .image(let image, _, let subtitle):
            addImageAndSubtitle(image, subtitle)
        }
    }
    
    private func addTitleAndSubtitle(_ title: String, _ subtitle: String) {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
    }
    
    private func addImageAndSubtitle(_ image: UIImage?, _ subtitle: String) {
        addSubview(imageView)
        addSubview(subtitleLabel)
        
        imageView.image = image
        subtitleLabel.text = subtitle
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(32.0)
            $0.top.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.bottom.left.right.equalToSuperview()
        }
    }
}
