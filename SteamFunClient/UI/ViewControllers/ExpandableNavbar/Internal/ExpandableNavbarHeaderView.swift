//
//  ExpandableNavbarHeaderView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

/// Хэдер на кастомном навбаре. Инкапсулирует UI и логику перехода элементов при скролле.
internal final class ExpandableNavbarHeaderView: UIView {
    
    // MARK: - Internal properties
    
    /// Кнопка назад.
    internal var backButton: ArrowView? {
        didSet {
            oldValue?.removeFromSuperview()
            addBackButton()
        }
    }
    
    /// Цвет бекграунда с блюром.
    internal var backgroundBlurColor: UIColor = .clear {
        didSet {
            self.headerBlurView.color = self.backgroundBlurColor
        }
    }
    
    internal private(set) var contentView: UIView?
    
    // MARK: - Private properties
    
    /// Блюр вью у хедера, которая размывает заезжающую под нее контент вью.
    private lazy var headerBlurView = BlurView(color: self.backgroundBlurColor)
    
    /// Контейнер для заголовка и подзаголовка
    private let contentContainerView = UIView()
    
    /// Констрейнт центрирования заголовка в хэдере по оси y. Его меняем для "подъезжания" заголовка.
    private var contentContainerCenterYConstraint: NSLayoutConstraint?
    
    /// Есть ли на заднем плане блюр.
    private let hasBlur: Bool
    
    private struct Constants {
        static let headerContentMaxOffsetY: CGFloat = 12.0
        static let contentContainerOffsetX: CGFloat = 12.0
    }
    
    // MARK: - Init
    
    init(hasBlur: Bool) {
        self.hasBlur = hasBlur
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal
    
    internal func addContentView(_ contentView: UIView) {
        removeContentView()
        self.contentView = contentView
        contentContainerView.addSubview(contentView)
        contentView.snp.pinToAllSuperviewEdges()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    internal func handleScrollViewDidScroll(diff: CGFloat, maxDiff: CGFloat, transitionStartDiff: CGFloat, transitionRatio: CGFloat) {
        let transitionDidNotStart = transitionRatio <= 0.0
        let transitionDidEnd = transitionRatio >= 1.0
        
        /// 1. Показыем/скрываем заголовок в хэдере
        let headerContentAlpha = transitionRatio >= 0.0
            ? transitionRatio
            : 0.0
        contentContainerView.alpha = headerContentAlpha
        
        /// 2. Меняем положение заголовка в хэдере, чтобы он "подъезжал"
        let headerContentContainerOffsetY: CGFloat
        if transitionDidNotStart {
            headerContentContainerOffsetY = Constants.headerContentMaxOffsetY
        } else if transitionDidEnd {
            headerContentContainerOffsetY = 0.0
        } else {
            headerContentContainerOffsetY = Constants.headerContentMaxOffsetY * (1 - transitionRatio)
        }
        contentContainerCenterYConstraint?.constant = headerContentContainerOffsetY + UIApplication.shared.statusBarHeight / 2
        contentContainerView.layoutIfNeeded()
        
        /// 3. Фейдим блюр у хедера, чтобы не было двойного размытия
        let headerBlurAlpha: CGFloat
        if transitionDidEnd {
            let distanceOfFadeOut: CGFloat = 10.0
            headerBlurAlpha = max((maxDiff - diff + distanceOfFadeOut) / distanceOfFadeOut, 0)
        } else {
            let distanceOfFadeIn: CGFloat = 4.0
            headerBlurAlpha = diff >= distanceOfFadeIn
                ? 1.0
                : 1.0 - (distanceOfFadeIn - diff) / distanceOfFadeIn
        }
        headerBlurView.alpha = headerBlurAlpha
    }
    
    // MARK: - UI
    
    private func configureUI() {
        if hasBlur {
            addBlurView()
        }
        addContentContainerView()
    }
    
    private func addBlurView() {
        headerBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        headerBlurView.frame = self.frame
        addSubview(self.headerBlurView)
    }
    
    private func addBackButton() {
        guard let backButton = self.backButton else { return }
        self.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(8.0)
            $0.bottom.equalToSuperview().offset(-8.0)
            $0.width.equalTo(32.0)
            $0.height.equalTo(36.0)
        }
    }
    
    private func addContentContainerView() {
        addSubview(contentContainerView)
        
        let containerCenterYConstraint = contentContainerView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        containerCenterYConstraint.constant = UIApplication.shared.statusBarHeight / 2
        containerCenterYConstraint.isActive = true
        self.contentContainerCenterYConstraint = containerCenterYConstraint
        
        let offsetX = Constants.contentContainerOffsetX
        contentContainerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.left.greaterThanOrEqualToSuperview()//.offset(offsetX)
            $0.right.lessThanOrEqualToSuperview()//.offset(-offsetX)
            $0.width.height.greaterThanOrEqualTo(0)
        }
    }
    
    private func removeContentView() {
        if let contentView = self.contentView {
            contentView.removeFromSuperview()
            self.contentView = nil
        }
    }
}
