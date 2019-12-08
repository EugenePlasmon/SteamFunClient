//
//  Dota2StatsViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2StatsViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let output: Dota2StatsViewOutput
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        if #available(iOS 13.0, *) {
            scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        }
        return scrollView
    }()
    private let contentView = UIView()
    private var navbar: ExpandableNavbar?
    
    // MARK: - Init
    
    init(output: Dota2StatsViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.output.viewDidLoad()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = FeatureColor.Dota2Stats.background
        navigationController?.isNavigationBarHidden = true
        addScrollViewAndContentView()
    }
    
    private func addScrollViewAndContentView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.toSuperviewBottomSafeArea(from: self)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.bottom.left.right.width.equalToSuperview()
        }
    }
    
    private var lastAddedBlock: UIView?
    private var lastAddedBlockBottomConstraint: NSLayoutConstraint?
    
    private func addBlockViewController(title: String, subViewController: UIViewController) {
        addChild(subViewController)
        addBlock(title: title, subview: subViewController.view)
    }
    
    private func addBlock(title: String, subview: UIView) {
        let containerView = UIView(color: .clear)
        let subContainerView = UIView(color: FeatureColor.Dota2Stats.blockBackground)
        let titleLabel = UILabel(text: title, color: FeatureColor.Dota2Stats.blockTitle, font: .kerrigan)
        
        contentView.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(subContainerView)
        subContainerView.addSubview(subview)
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(lastAddedBlock?.snp.bottom ?? contentView.snp.top).offset(16.0)
            $0.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview().inset(12.0)
        }
        
        subContainerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            $0.left.bottom.right.equalToSuperview()
        }
        
        subview.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4.0)
            $0.left.right.equalToSuperview()
        }
        
        self.lastAddedBlockBottomConstraint?.isActive = false
        self.lastAddedBlockBottomConstraint = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0)
        self.lastAddedBlockBottomConstraint?.isActive = true
        self.lastAddedBlock = containerView
    }
}

// MARK: - Dota2StatsViewInput

extension Dota2StatsViewController: Dota2StatsViewInput {
    
    func addNavbar(imageUrl: String?, title: String) {
        let navbar = ExpandableNavbar(scrollView: scrollView, config: defaultNavbarConfig)
        self.navbar = navbar
        
        let navbarHeaderContentView = ExpandableNavbar.HeaderContentView.ImageAndText()
        navbarHeaderContentView.imageUrl = imageUrl
        navbarHeaderContentView.title = title
        
        addChild(navbar)
        view.addSubview(navbar.view)
        navbar.view.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        navbar.addHeaderContentView(navbarHeaderContentView)
        
        scrollView.scrollIndicatorInsets = .top(navbar.minimumHeight)
    }
    
    func addPlot(_ plotView: Plot) {
        plotView.onStartTouches = { [weak self] in
            self?.scrollView.isScrollEnabled = false
        }
        plotView.onEndTouches = { [weak self] in
            self?.scrollView.isScrollEnabled = true
        }
        addBlock(title: "Прогресс игрока", subview: plotView)
    }
    
    func addTopHeroesBlock(with viewController: UIViewController) {
        addBlockViewController(title: "Статистика по героям", subViewController: viewController)
    }
}
