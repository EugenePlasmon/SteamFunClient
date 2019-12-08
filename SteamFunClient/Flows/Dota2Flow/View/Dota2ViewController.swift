//
//  Dota2ViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2ViewController: UIViewController {
    
    let output: Dota2ViewOutput
    
    private var throbberViewController: ThrobberViewController?
    private var matchHistoryHeaderView: Dota2MatchHistoryHeaderView?
    private var matchHistoryViewController: Dota2MatchHistoryViewController?
    
    private var matchHistoryHeaderTopConstraint: NSLayoutConstraint?
    
    private lazy var navbarConfig = self.defaultNavbarConfig
    private var navbar: ExpandableNavbar?
    
    private let progressLabel = UILabel(text: "Загружаем историю матчей...", color: FeatureColor.Dota2.loadingInfoText, font: .brakk, numberOfLines: 0, textAlignment: .center)
    private let progressView = UIProgressView()
    
    private struct Constants {
        static let matchCellHeight: CGFloat = 82.0
    }
    
    // MARK: - Init
    
    init(output: Dota2ViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        output.viewDidLoad()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = FeatureColor.Dota2.background
        navigationController?.isNavigationBarHidden = true
    }
    
    private func addProgressViewWithLabel() {
        view.addSubview(progressLabel)
        view.addSubview(progressView)
        
        progressLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(36.0)
            $0.left.right.equalToSuperview().inset(36.0)
        }
        
        progressView.snp.makeConstraints {
            $0.top.equalTo(progressLabel.snp.bottom).offset(4.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(160.0)
        }
    }
    
    private func addNavbar(viewModel: Dota2ViewModel.Navbar) {
        let navbar = ExpandableNavbar(scrollView: matchHistoryViewController?.tableView, config: navbarConfig)
        self.navbar = navbar
        
        let navbarHeaderContentView = ExpandableNavbar.HeaderContentView.ImageAndText()
        navbarHeaderContentView.imageUrl = viewModel.iconUrl
        navbarHeaderContentView.title = viewModel.title
        
        addChild(navbar)
        view.addSubview(navbar.view)
        navbar.view.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        navbar.addHeaderContentView(navbarHeaderContentView)
        
        matchHistoryViewController?.tableView.scrollIndicatorInsets = .top(navbar.minimumHeight)
    }
    
    private func addMatchHistoryHeader() {
        guard let navbarView = navbar?.view, let scrollView = navbar?.scrollView else {
            return
        }
        
        let matchHistoryHeaderView = Dota2MatchHistoryHeaderView()
        self.matchHistoryHeaderView = matchHistoryHeaderView
        view.addSubview(matchHistoryHeaderView)
        
        let headerTopConstraint = matchHistoryHeaderView.topAnchor.constraint(equalTo: navbarView.bottomAnchor)
        headerTopConstraint.isActive = true
        self.matchHistoryHeaderTopConstraint = headerTopConstraint
        updateHeaderViewPosition(with: scrollView)
        
        matchHistoryHeaderView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    
    private func addMatchHistoryViewController(viewModel: Dota2ViewModel) {
        let matchHistoryViewController = Dota2MatchHistoryViewController(viewModel: viewModel)
        self.matchHistoryViewController = matchHistoryViewController
        matchHistoryViewController.onShortStatsTap = { [weak self] in
            self?.output.viewDidTapMoreStats()
        }
        matchHistoryViewController.onScrollViewDidScroll = { [weak self] scrollView in
            self?.updateHeaderViewPosition(with: scrollView)
        }
        
        addChild(matchHistoryViewController)
        if let matchHistoryHeaderView = matchHistoryHeaderView {
            view.insertSubview(matchHistoryViewController.view, belowSubview: matchHistoryHeaderView)
        } else {
            view.addSubview(matchHistoryViewController.view)
        }
        
        matchHistoryViewController.view.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.toSuperviewBottomSafeArea(from: self)
        }
    }
    
    private func updateHeaderViewPosition(with scrollView: UIScrollView) {
        let scrolled = scrollView.contentInset.top + scrollView.contentOffset.y
        let shortStatsHeight = Dota2MatchHistoryViewController.CellType.shortStats.cellHeight
        let insetTop = navbarConfig.scrollViewInsets.top
        let diff = shortStatsHeight + insetTop - scrolled
        matchHistoryHeaderTopConstraint?.constant = diff > 0 ? diff : 0.0
    }
    
    private func removeThrobberViewController() {
        throbberViewController?.removeFromParent()
        throbberViewController?.view.removeFromSuperview()
        throbberViewController = nil
        
        progressView.removeFromSuperview()
        progressLabel.removeFromSuperview()
    }
    
    // MARK: - Error
    
    private var errorLabel: UILabel?
    
    private func addErrorLabel(message: String) {
        errorLabel = UILabel(text: message, color: FeatureColor.Dota2.errorText, font: .brakk, numberOfLines: 0, textAlignment: .center)
        errorLabel >>- view.addSubview
        errorLabel?.snp.makeConstraints {
            $0.top.equalToSuperview().offset((navbar?.minimumHeight ?? 64.0) + 24.0)
            $0.left.right.equalToSuperview().inset(16.0)
        }
    }
}

extension Dota2ViewController: Dota2ViewInput {
    
    func showLoader() {
        let throbberViewController = ThrobberViewController()
        self.throbberViewController = throbberViewController
        addChild(throbberViewController)
        view.addSubview(throbberViewController.view)
        throbberViewController.view.snp.pinToAllSuperviewEdges()
        
        addProgressViewWithLabel()
    }
    
    func updateLoadingProgress(value: Float) {
        progressView.setProgress(value, animated: true)
    }
    
    func showData(viewModel: Dota2ViewModel) {
        removeThrobberViewController()
        addMatchHistoryViewController(viewModel: viewModel)
        addNavbar(viewModel: viewModel.navbar)
        addMatchHistoryHeader()
    }
    
    func showError(message: String, navbarModel: Dota2ViewModel.Navbar) {
        removeThrobberViewController()
        addNavbar(viewModel: navbarModel)
        addErrorLabel(message: message)
    }
}
