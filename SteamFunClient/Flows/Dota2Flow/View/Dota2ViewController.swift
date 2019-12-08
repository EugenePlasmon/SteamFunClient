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
    private var shortStatsViewController: Dota2ShortStatsViewController?
    private var matchHistoryHeaderView: Dota2MatchHistoryHeaderView?
    private var matchHistoryViewController: Dota2MatchHistoryViewController?
    
    private var matchHistoryHeaderTopConstraint: NSLayoutConstraint?
    
    private lazy var navbarConfig = self.defaultNavbarConfig
    private var navbar: ExpandableNavbar?
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.delegate = self
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
    
    private struct Constants {
        static let matchCellHeight: CGFloat = 82.0
    }
    
    init(output: Dota2ViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        output.viewDidLoad()
    }
    
    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = FeatureColor.Dota2.background
        navigationController?.isNavigationBarHidden = true
        addScrollViewAndContentView()
    }
    
    private func addScrollViewAndContentView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.bottom.equalToSuperview()
            }
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.top.bottom.left.right.width.equalToSuperview()
        }
    }
    
    private func addNavbar(viewModel: Dota2ViewModel.Navbar) {
        let navbar = ExpandableNavbar(scrollView: scrollView, config: navbarConfig)
        self.navbar = navbar
        
        let navbarHeaderContentView = ExpandableNavbar.HeaderContentView.ImageAndText()
        navbarHeaderContentView.imageUrl = viewModel.iconUrl
        navbarHeaderContentView.title = viewModel.title
        
        addChild(navbar)
        view.addSubview(navbar.view)
        navbar.view.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        navbar.addHeaderContentView(navbarHeaderContentView)
        
        scrollView.scrollIndicatorInsets = .top(navbar.minimumHeight)
    }
    
    private func addShortStats(viewModel: Dota2ViewModel) {
        let shortStatsViewController = Dota2ShortStatsViewController(viewModel: viewModel.shortStats)
        shortStatsViewController.onMoreTap = { [weak self] in
            self?.output.viewDidTapMoreStats()
        }
        self.shortStatsViewController = shortStatsViewController
        addChild(shortStatsViewController)
        contentView.addSubview(shortStatsViewController.view)
        shortStatsViewController.view.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
    }
    
    private func addMatchHistoryHeader() {
        let matchHistoryHeaderView = Dota2MatchHistoryHeaderView()
        self.matchHistoryHeaderView = matchHistoryHeaderView
        contentView.addSubview(matchHistoryHeaderView)
        
        let headerTopConstraint = matchHistoryHeaderView.topAnchor.constraint(equalTo: shortStatsViewController?.view.bottomAnchor ?? contentView.bottomAnchor)
        headerTopConstraint.isActive = true
        self.matchHistoryHeaderTopConstraint = headerTopConstraint
        
        matchHistoryHeaderView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    
    private func addMatchHistoryViewController(viewModel: Dota2ViewModel) {
        let matchHistoryViewController = Dota2MatchHistoryViewController(matches: viewModel.matches)
        self.matchHistoryViewController = matchHistoryViewController
        addChild(matchHistoryViewController)
        if let matchHistoryHeaderView = matchHistoryHeaderView {
            contentView.insertSubview(matchHistoryViewController.view, belowSubview: matchHistoryHeaderView)
        } else {
            contentView.addSubview(matchHistoryViewController.view)
        }
        
        matchHistoryHeaderView?.setNeedsLayout()
        matchHistoryHeaderView?.layoutIfNeeded()
        let headerHeight = matchHistoryHeaderView?.frame.height ?? 0.0
        
        matchHistoryViewController.view.snp.makeConstraints {
            $0.top.equalTo(shortStatsViewController?.view.snp.bottom ?? contentView.snp.top).offset(headerHeight)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(CGFloat(viewModel.matches.count) * Constants.matchCellHeight)
        }
    }
    
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
    }
    
    private func removeThrobberViewController() {
        throbberViewController?.removeFromParent()
        throbberViewController?.view.removeFromSuperview()
        throbberViewController = nil
    }
    
    func showData(viewModel: Dota2ViewModel) {
        removeThrobberViewController()
        addNavbar(viewModel: viewModel.navbar)
        addShortStats(viewModel: viewModel)
        addMatchHistoryHeader()
        addMatchHistoryViewController(viewModel: viewModel)
    }
    
    func showError(message: String, navbarModel: Dota2ViewModel.Navbar) {
        removeThrobberViewController()
        addNavbar(viewModel: navbarModel)
        addErrorLabel(message: message)
    }
}

// MARK: - UIScrollViewDelegate

extension Dota2ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrolled = scrollView.contentInset.top + scrollView.contentOffset.y
        let shortStatsHeight = shortStatsViewController?.view.bounds.height ?? 0
        let insetTop = navbarConfig.scrollViewInsets.top
        let diff = scrolled - (shortStatsHeight + insetTop)
        matchHistoryHeaderTopConstraint?.constant = diff > 0 ? diff : 0.0
    }
}
