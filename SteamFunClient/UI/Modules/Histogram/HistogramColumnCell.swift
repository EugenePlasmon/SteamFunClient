//
//  HistogramColumnCell.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class HistogramColumnCell: UICollectionViewCell {
    
    static let reuseIdentifier = "HistogramColumnReuseIdentifier"
    
    var columnRelativeHeight: CGFloat = 0.0 {
        didSet {
            if columnRelativeHeight < 0 { columnRelativeHeight = 0 }
            if columnRelativeHeight > 1 { columnRelativeHeight = 1 }
            guard columnRelativeHeight != oldValue else { return }
            updateColumnHeightConstraint()
        }
    }
    
    var imageName: String? {
        didSet {
            guard let imageName = imageName else {
                subImageView.isHidden = true
                return
            }
            subImageView.isHidden = false
            subImageView.image = UIImage(named: imageName)
        }
    }
    
    var imageRounded: Bool = false {
        didSet {
            subImageView.rounded = imageRounded
        }
    }
    
    private let columnContainerView = UIView()
    let columnView = UIView()
    let valueLabel = UILabel()
    let subImageView = RoundedImageView(contentMode: .scaleAspectFill)
    
    private var columnHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(columnContainerView)
        columnContainerView.addSubview(columnView)
        columnContainerView.addSubview(valueLabel)
        contentView.addSubview(subImageView)
        
        subImageView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview().inset(2.0)
            $0.height.equalTo(subImageView.snp.width)
        }
        
        columnContainerView.snp.makeConstraints {
            $0.bottom.equalTo(subImageView.snp.top).offset(-2.0)
            $0.left.right.top.equalToSuperview()
        }
        
        columnView.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
        }
        
        valueLabel.snp.makeConstraints {
            $0.bottom.equalTo(columnView.snp.top).offset(-2.0)
            $0.centerX.equalTo(columnView)
        }
        
        updateColumnHeightConstraint()
    }
    
    private func updateColumnHeightConstraint() {
        self.columnHeightConstraint?.isActive = false
        self.columnHeightConstraint = columnView.heightAnchor.constraint(equalTo: columnContainerView.heightAnchor, multiplier: columnRelativeHeight)
        self.columnHeightConstraint?.isActive = true
    }
}
