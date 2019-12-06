//
//  NavbarHeaderImageAndTextContentView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

extension ExpandableNavbar {
    
    struct HeaderContentView { }
}

// MARK: - ImageAndText

extension ExpandableNavbar.HeaderContentView {
    
    final class ImageAndText: UIView {
        
        var imageUrl: String? {
            didSet {
                guard let imageUrl = imageUrl else {
                    imageView.isHidden = true
                    return
                }
                imageView.isHidden = false
                URL(string: imageUrl) >>- { imageView.kf.setImage(with: $0) }
            }
        }
        
        var title: String? {
            get { titleLabel.text }
            set { titleLabel.text = newValue }
        }
        
        // MARK: - Views
        
        private lazy var imageView: UIImageView = {
            let avatar = UIImageView()
            avatar.layer.masksToBounds = true
            avatar.layer.cornerRadius = Constants.linearSize / 2
            avatar.layer.borderColor = UIColor.selendis.cgColor
            avatar.layer.borderWidth = 1.0
            return avatar
        }()
        
        private let titleLabel = UILabel(color: FeatureColor.Profile.name,
                                         font: .stukov)
        
        private struct Constants {
            static let linearSize: CGFloat = 30.0
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
            
            addSubview(imageView)
            addSubview(titleLabel)
            
            imageView.snp.makeConstraints {
                $0.left.top.bottom.equalToSuperview()
                $0.width.height.equalTo(Constants.linearSize)
            }
            
            titleLabel.snp.makeConstraints {
                $0.centerY.equalTo(imageView)
                $0.left.equalTo(imageView.snp.right).offset(10.0)
                $0.right.equalToSuperview()
            }
            
        }
    }
}

// MARK: - Text

extension ExpandableNavbar.HeaderContentView {
    
    final class Text: UIView {
        
        var title: String? {
            get { titleLabel.text }
            set { titleLabel.text = newValue }
        }
        
        // MARK: - Views
        
        private let titleLabel = UILabel(color: FeatureColor.Profile.name,
                                         font: .stukov)
        
        private struct Constants {
            static let linearSize: CGFloat = 30.0
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
            
            addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints {
                $0.left.top.bottom.right.equalToSuperview()
                $0.height.equalTo(Constants.linearSize)
            }
        }
    }
}
