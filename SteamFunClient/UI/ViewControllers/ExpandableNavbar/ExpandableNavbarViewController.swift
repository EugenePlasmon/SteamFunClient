//
//  ExpandableNavbarViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import SnapKit

/// Кастомный навигейшн бар в виде вью контроллера.
/// Поведение скроллинга и инсетов скролл вью инкапсулируется в этом классе.
public final class ExpandableNavbarViewController: UIViewController, CustomNavbarSnappingBehavior, CustomNavbarScrollViewInsetsBehavior {
    
    public struct Config {
        public var backgroundBlurColor: UIColor
        public var showBackButton: Bool
        public var scrollViewInsets: UIEdgeInsets = .zero
        public var hasBlur: Bool
    }
    
    // MARK: - Public properties
    
    /// Замыкание, которое выполнится при нажатии юзером кнопки назад.
    public var onBackButtonTap: (() -> Void)? {
        didSet {
            self.headerView.onBackButtonTap = self.onBackButtonTap
        }
    }
    
    public var config: Config {
        didSet {
            if config.backgroundBlurColor != oldValue.backgroundBlurColor {
                headerView.backgroundBlurColor = config.backgroundBlurColor
                blurView?.color = config.backgroundBlurColor
            }
            if config.showBackButton != oldValue.showBackButton {
                headerView.backButton.isHidden = !config.showBackButton
            }
            if config.scrollViewInsets != oldValue.scrollViewInsets {
                updateScrollViewInsets()
            }
            if config.hasBlur != oldValue.hasBlur {
                blurView?.removeFromSuperview()
                if config.hasBlur {
                    addBlurView()
                }
            }
        }
    }
    
    /// Максимальная высота навбара (т.е. в развернутом состоянии).
    public var maximumHeight: CGFloat {
        return Constants.headerHeight + self.contentHeight
    }
    
    /// Минимальная высота навбара (т.е. в свернутом состоянии).
    public var minimumHeight: CGFloat {
        return Constants.headerHeight
    }
    
    // MARK: - Internal properties
    
    /// Скролл вью, на скролл которой реагирует навбар.
    /// Также навбар инкапсулирует задание `contentInsets` для этой скролл вью.
    internal weak var scrollView: UIScrollView?
    
    var scrollViewInsets: UIEdgeInsets {
        get { config.scrollViewInsets }
        set { self.config.scrollViewInsets = newValue }
    }
    
    // MARK: - Private properties
    
    private var blurView: BlurView?
    
    /// Шапка, в которой располагается кнопка назад и заголовок.
    private lazy var headerView = ExpandableNavbarHeaderView(hasBlur: config.hasBlur && self.scrollView != nil)
    
    /// Вью для контента под шапкой, на которую добавляется кастомная вью или вью контроллер с контентом.
    private let contentContainerView = UIView()
    
    /// Вью в `contentContainerView` или `nil`, если не была добавлена извне с помощью метода `addContentView(_:)`
    private var contentView: ExpandableNavbarContentView?
    
    /// Констрейнт контент вью к верху навбара. Его меняем для эффекта схлопывания/разворачивания навбара.
    private var contentViewTopConstraint: NSLayoutConstraint?
    
    /// Высота контент вью. Рассчитывается после того, как лэйаут польностью обновился, и используется в свойстве `maximumHeight`.
    private var contentHeight: CGFloat = 0.0
    
    /// Если `true` - то при каждом изменении высоты контента (например, после лэйаута контент вью),
    /// сколл-вью без анимации проскроллится к началу (верху). По дефолту `false`.
    private var needsScrollToBeginAfterContentHeightChange = false
    
    private struct Constants {
        static var headerHeight: CGFloat {
            return 44.0 + UIApplication.shared.statusBarHeight
        }
        static let tabControlHeight: CGFloat = 32.0
        static let tabControlOffsetFromContent: CGFloat = 24.0
        static let tabControlOffsetFromHeaderInCollapsedState: CGFloat = 6.0
        static let transitionStartRatio: CGFloat = 0.75
    }
    
    // MARK: - Init
    
    /// Инициализатор кастомного навбара.
    ///
    /// - Parameters:
    ///   - scrollView: Скролл вью или её сабкласс, на скролл которой реагирует навбар.
    ///   - config: Конфиг.
    public init(scrollView: UIScrollView?,
                config: Config) {
        self.scrollView = scrollView
        self.config = config
        super.init(nibName: nil, bundle: nil)
        if #available(iOS 11.0, *) {
            scrollView?.contentInsetAdjustmentBehavior = .never
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public
    
    public func addContentView(_ contentView: ExpandableNavbarContentView) {
        removeContentView()
        self.contentView = contentView
        contentView.output = self
        contentContainerView.addSubview(contentView)
        contentView.snp.pinToAllSuperviewEdges()
        self.needsScrollToBeginAfterContentHeightChange = true
        view.setNeedsLayout()
        view.layoutIfNeeded()
        self.needsScrollToBeginAfterContentHeightChange = false
        scrollView >>- { scrollViewDidScroll($0) }
    }
    
    public func addHeaderContentView(_ headerContentView: UIView) {
        headerView.addContentView(headerContentView)
        updateScrollViewInsets()
        scrollView?.scrollToBegin()
        scrollView >>- { scrollViewDidScroll($0) }
    }
    
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateScrollViewAppearance()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateContentHeight()
    }
    
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        /// При поворотах/переходах в другой размер
        /// необходимо обновить все констрейнты и состояния согласно новым инсетам скролл вью.
        let updateScrollViewClosure = { [weak self] in
            self?.updateScrollViewAppearance()
        }
        coordinator.animate(alongsideTransition: { _ in
            updateScrollViewClosure()
        }, completion: { _ in
            updateScrollViewClosure()
        })
    }
    
    public override func removeFromParent() {
        removeContentView()
        super.removeFromParent()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.applyShadow(.aiur)
        if config.hasBlur {
            addBlurView()
        }
        addHeaderView()
        addContentContainerView()
    }
    
    private func addBlurView() {
        let blurView = BlurView(color: config.backgroundBlurColor, opacity: 0.9, blurRadius: 8.0)
        self.blurView = blurView
        view.insertSubview(blurView, at: 0)
        blurView.snp.pinToAllSuperviewEdges()
    }
    
    private func addHeaderView() {
        view.addSubview(self.headerView)
        
        headerView.backButton.isHidden = !config.showBackButton
        
        headerView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(Constants.headerHeight)
        }
    }
    
    private func addContentContainerView() {
        view.insertSubview(self.contentContainerView, belowSubview: headerView)
        contentContainerView.backgroundColor = UIColor.clear
        
        let contentViewTopConstraint =
            contentContainerView.topAnchor.constraint(equalTo: view.topAnchor,
                                                      constant: Constants.headerHeight)
        contentViewTopConstraint.isActive = true
        self.contentViewTopConstraint = contentViewTopConstraint
        
        contentContainerView.snp.makeConstraints { $0.left.right.bottom.equalToSuperview() }
    }
    
    // MARK: - Private
    
    private func removeContentView() {
        if let contentView = self.contentView {
            contentView.removeFromSuperview()
            self.contentView = nil
        }
    }
    
    private func updateContentHeight() {
        let oldContentHeight = contentHeight
        contentHeight = contentView?.bounds.height ?? 0.0
        
        if contentHeight != oldContentHeight {
            updateScrollViewInsets()
            
            if needsScrollToBeginAfterContentHeightChange {
                scrollView?.scrollToBegin()
            }
        }
    }
    
    private func updateScrollViewAppearance() {
        scrollView >>- { scrollViewDidScroll($0) }
    }
}

// MARK: - UIScrollViewDelegate
extension ExpandableNavbarViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 0. Предварительные расчеты
        let diff = max(scrollView.contentOffset.y + scrollView.contentInset.top, 0)
        let maxHeight = self.maximumHeight
        let minHeight = self.minimumHeight
        let maxDiff = maxHeight - minHeight
        let transitionStartDiff = Constants.transitionStartRatio * maxDiff
        guard maxDiff - transitionStartDiff != 0 else {
            return
        }
        let transitionRatioRaw = (diff - transitionStartDiff) / (maxDiff - transitionStartDiff)
        let transitionRatio = min(1.0, max(0.0, transitionRatioRaw))
        let calculatedHeight = maxHeight - diff
        
        // 1. Двигаем contentView
        let diffToApply = calculatedHeight <= minHeight ? maxDiff : diff
        let topConstraint = Constants.headerHeight - diffToApply
        self.contentViewTopConstraint?.constant = topConstraint
        
        // 2. Фейдим контент вью
        let contentAlpha = diff >= transitionStartDiff
            ? 1.0 - transitionRatio
            : 1.0
        self.contentContainerView.alpha = contentAlpha
        
        // 3. Передаем расчеты в хэдер вью для изменений в нем.
        self.headerView.handleScrollViewDidScroll(diff: diff, maxDiff: maxDiff, transitionStartDiff: transitionStartDiff, transitionRatio: transitionRatio)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.snapScrollView(scrollView, targetContentOffset: targetContentOffset)
    }
}

// MARK: - ExpandableNavbarContentViewOutput
extension ExpandableNavbarViewController: ExpandableNavbarContentViewOutput {
    
    public func contentViewDidLayoutSubviews() {
        self.updateContentHeight()
    }
}
