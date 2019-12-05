//
//  ImageWithSubtextView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class ImageWithSubtextView: UIView {
    
    // MARK: - Properties
    
    let textColor: UIColor
    let isImageRounded: Bool
    let imageStrokeColor: UIColor?
    
    var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    // MARK: - Init
    
    init(textColor: UIColor, isImageRounded: Bool, imageStrokeColor: UIColor? = nil) {
        self.textColor = textColor
        self.isImageRounded = isImageRounded
        self.imageStrokeColor = imageStrokeColor
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isImageRounded {
            imageView.layer.cornerRadius = imageView.frame.width / 2
        }
    }
    
    // MARK: - UI
    
    private let imageView = UIImageView(contentMode: .scaleAspectFill, clipsToBounds: true)
    private lazy var label = UILabel(color: textColor, font: .zurvan, numberOfLines: 1, textAlignment: .center)
    
    private func configureUI() {
        if let imageStrokeColor = self.imageStrokeColor {
            imageView.layer.borderWidth = 2.0
            imageView.layer.borderColor = imageStrokeColor.cgColor
        }
        
        addSubview(imageView)
        addSubview(label)
        
        imageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.height.equalTo(32.0)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4.0)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
