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
        case achievements(count: Int)
        case more
    }
    
    let type: Type
    
    typealias OnTapClosure = (Type) -> Void
    var onTap: OnTapClosure?
    
    private lazy var numberLabel = UILabel(font: Constants.numberFont, textAlignment: .center, contentHuggingPriorityY: .required)
    private lazy var textLabel = UILabel(font: Constants.textFont, textAlignment: .center, contentHuggingPriorityY: .required)
    private lazy var moreContainer = TouchThroughView()
    private lazy var more = UIView.More()
    
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
            addNumberAndTextLabels()
            numberLabel.text = "\(count)"
            textLabel.text = String.plural(forCount: count,
                                           zeroFiveTen: "друзей",
                                           one: "друг",
                                           twoFour: "друга")
        case .achievements(let count):
            addNumberAndTextLabels()
            numberLabel.text = "\(count)"
            textLabel.text = String.plural(forCount: count,
                                           zeroFiveTen: "призов",
                                           one: "приз",
                                           twoFour: "приза")
        case .more:
            addMoreAndTextLabel()
            textLabel.text = "подробнее"
        }
        updateColors()
    }
    
    private func addNumberAndTextLabels() {
        addSubview(numberLabel)
        addSubview(textLabel)
        
        numberLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        textLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(numberLabel.snp.bottom)
        }
    }
    
    private func addMoreAndTextLabel() {
        addSubview(moreContainer)
        moreContainer.addSubview(more)
        addSubview(textLabel)
        
        moreContainer.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
        
        more.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-10.0)
            $0.width.equalTo(36.0)
            $0.height.equalTo(8.0)
        }
        textLabel.snp.makeConstraints {
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(moreContainer.snp.bottom)
        }
    }
    
    private func updateColors() {
        let color = isHighlighted ? Constants.pressedColor : Constants.defaultColor
        switch type {
        case .friends, .achievements:
            numberLabel.textColor = color
            textLabel.textColor = color
        case .more:
            more.color = color
            textLabel.textColor = color
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
