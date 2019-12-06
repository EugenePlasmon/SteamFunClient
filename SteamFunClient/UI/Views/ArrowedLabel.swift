//
//  ArrowedLabel.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class ArrowedLabel: UIControl {
    
    // MARK: - Properties
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    var color: UIColor {
        didSet {
            updateColors()
        }
    }
    
    var font: UIFont {
        get { label.font }
        set { label.font = newValue }
    }
    
    var onTap: (() -> Void)?
    
    override var isHighlighted: Bool {
        didSet {
            updateColors()
        }
    }
    
    // MARK: - Views
    
    private let label = UILabel(compressionResistancePriorityX: .required)
    private let arrowView = ArrowView(direction: .right, insets: .init(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0))
    
    // MARK: - Init
    
    init(text: String? = nil, color: UIColor = .artanis, font: UIFont = .brakk) {
        self.color = color
        super.init(frame: .zero)
        self.text = text
        self.font = font
        configureUI()
        configureActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        updateColors()
        
        addSubview(label)
        addSubview(arrowView)
        
        label.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
        }
        
        arrowView.snp.makeConstraints {
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(arrowView.snp.height).multipliedBy(0.5)
            $0.left.equalTo(label.snp.right).offset(8.0)
        }
    }
    
    private func updateColors() {
        let color = isHighlighted ? highlightedColor : self.color
        label.textColor = color
        arrowView.color = color
    }
    
    private var highlightedColor: UIColor {
        return themeDependent(dark: self.color.darken(by: 0.2), light: self.color.lighten(by: 0.2))
    }
    
    // MARK: - Actions
    
    private func configureActions() {
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc private func didTap() {
        onTap?()
    }
}
