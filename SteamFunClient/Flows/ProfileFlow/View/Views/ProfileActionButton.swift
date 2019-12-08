//
//  ProfileActionButton.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 26.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class ProfileActionButton: UIControl {
    
    enum `Type` {
        case friends(count: Int)
        case hiddenFriends
        case logout
    }
    
    let type: Type
    
    typealias OnTapClosure = (Type) -> Void
    var onTap: OnTapClosure?
    
    private lazy var numberLabel = UILabel(font: Constants.numberFont, textAlignment: .center, compressionResistancePriorityY: .required, contentHuggingPriorityY: .required)
    private lazy var textLabel = UILabel(font: Constants.textFont, textAlignment: .center, compressionResistancePriorityY: .required, contentHuggingPriorityY: .required)
    private lazy var logoutIconView = UIImageView(contentMode: .scaleAspectFit)
    
    private struct Constants {
        static let defaultColor: UIColor = FeatureColor.Profile.actionButtonDefault
        static let pressedColor: UIColor = FeatureColor.Profile.actionButtonPressed
        static let numberFont: UIFont = .kerrigan
        static let textFont: UIFont = .zurvan
    }
    
    // MARK: - Init
    
    init(type: Type) {
        self.type = type
        super.init(frame: .zero)
        configureUI()
        configureActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        switch type {
        case .friends(let count):
            configureAsFriends()
            numberLabel.text = "\(count)"
            textLabel.text = String.plural(forCount: count,
                                           zeroFiveTen: "друзей",
                                           one: "друг",
                                           twoFour: "друга")
            isUserInteractionEnabled = count > 0
        case .hiddenFriends:
            isUserInteractionEnabled = false
            configureAsHiddenFriends()
            textLabel.text = "Друзья\nскрыты"
        case .logout:
            addLogoutIconAndTextLabel()
            logoutIconView.image = UIImage(named: "logout_icon")
            textLabel.text = "Выйти"
        }
        updateColors()
    }
    
    private func configureAsFriends() {
        addSubview(numberLabel)
        addSubview(textLabel)
        
        numberLabel.numberOfLines = 1
        textLabel.numberOfLines = 1
        
        numberLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        textLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(numberLabel.snp.bottom)
        }
    }
    
    private func configureAsHiddenFriends() {
        addSubview(textLabel)
        textLabel.snp.pinToAllSuperviewEdges()
        textLabel.numberOfLines = 0
    }
    
    private func addLogoutIconAndTextLabel() {
        addSubview(logoutIconView)
        addSubview(textLabel)
        
        logoutIconView.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-2.0)
            $0.top.equalToSuperview()
            $0.width.equalTo(22.0)
            $0.height.equalTo(20.0)
        }
        
        textLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(logoutIconView.snp.bottom).offset(4.0)
        }
    }
    
    private func updateColors() {
        switch type {
        case .friends(let count):
            let alpha: CGFloat = count > 0 ? 1.0 : 0.5
            let color = (isHighlighted ? Constants.pressedColor : Constants.defaultColor).withAlphaComponent(alpha)
            numberLabel.textColor = color
            textLabel.textColor = color
        case .hiddenFriends:
            textLabel.textColor = Constants.defaultColor.withAlphaComponent(0.5)
        case .logout:
            let color = isHighlighted ? Constants.pressedColor : Constants.defaultColor
            textLabel.textColor = color
            logoutIconView.alpha = isHighlighted ? 0.8 : 1.0
        }
    }
    
    // MARK: - Actions
    
    override var isHighlighted: Bool {
        didSet {
            guard isHighlighted != oldValue else { return }
            updateColors()
        }
    }
    
    private func configureActions() {
        addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    }
    
    @objc private func didTouchUpInside() {
        onTap?(type)
    }
}

extension UIView {
    
    final class More: TouchThroughView {
        
        var color: UIColor = .artanis {
            didSet { setNeedsDisplay() }
        }
        
        init() {
            super.init(frame: .zero)
            isOpaque = false
            backgroundColor = .clear
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            setNeedsDisplay()
        }
        
        override func draw(_ rect: CGRect) {
            guard let context = UIGraphicsGetCurrentContext() else { return }
            let circleDiameter = rect.height
            let circleRadius = circleDiameter / 2
            let width = rect.width
            let gap = (width - 3 * circleDiameter) / 2
            let center1 = CGPoint(x: circleRadius, y: rect.height / 2)
            let center2 = CGPoint(x: circleDiameter + gap + circleRadius, y: rect.height / 2)
            let center3 = CGPoint(x: 2 * (circleDiameter + gap) + circleRadius, y: rect.height / 2)
            
            context.setFillColor(color.cgColor)
            context.addArc(center: center1, radius: circleRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            context.fillPath()
            context.addArc(center: center2, radius: circleRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            context.fillPath()
            context.addArc(center: center3, radius: circleRadius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            context.fillPath()
        }
    }
}
