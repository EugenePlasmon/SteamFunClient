//
//  ProfileViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    private let output: ProfileViewOutput
    
    // MARK: - Views
    
    private var throbberViewController: ThrobberViewController?
    
    private var ownedGamesViewController: GamesTableViewController?
    
    private var navbar: ExpandableNavbar?
    private var navbarContentView: ProfileNavbarContentView?
    private var navbarHeaderContentView: ExpandableNavbar.HeaderContentView.ImageAndText?
    private lazy var hiddenProfileLabel = UILabel(text: "Профиль скрыт настройками приватности", color: .ulrezaj, font: .brakk, numberOfLines: 0, textAlignment: .center)
    
    // MARK: - Init
    
    init(output: ProfileViewOutput) {
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
        self.automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = FeatureColor.Profile.background
        navigationController?.isNavigationBarHidden = true
    }
    
    private func addOwnedGamesViewController(viewModel: ProfileViewModel) {
        let ownedGamesViewController = GamesTableViewController(games: viewModel.ownedGames)
        ownedGamesViewController.onDotaSelect = { [weak self] in
            self?.output.viewDidTapDota()
        }
        ownedGamesViewController.onGameSelect = { [weak self] game in
            self?.output.viewDidTapGame(game)
        }
        navbar?.scrollView = ownedGamesViewController.tableView
        self.ownedGamesViewController = ownedGamesViewController
        addChild(ownedGamesViewController)
        view.addSubview(ownedGamesViewController.view)
        ownedGamesViewController.view.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.toSuperviewBottomSafeArea(from: self)
        }
    }
    
    private func addHiddenProfileLabel() {
        view.addSubview(hiddenProfileLabel)
        hiddenProfileLabel.snp.makeConstraints {
            if let navbar = navbar?.view {
                $0.top.equalTo(navbar.snp.bottom).offset(28.0)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview().multipliedBy(0.6)
            }
        }
    }
    
    private func addNavbar(viewModel: ProfileViewModel) {
        let navbar = ExpandableNavbar(scrollView: ownedGamesViewController?.tableView, config: defaultNavbarConfig)
        let navbarContentView = ProfileNavbarContentView(viewModel: viewModel)
        navbarContentView.onActionButtonTap = { [weak self] type in
            switch type {
            case .friends:
                self?.output.viewDidTapFriends()
            case .hiddenFriends:
                return
            case .logout:
                self?.output.viewDidTapLogout()
            }
        }
        
        self.navbar = navbar
        self.navbarContentView = navbarContentView
        
        addChild(navbar)
        view.addSubview(navbar.view)
        navbar.view.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        navbar.addContentView(navbarContentView)
        ownedGamesViewController?.navbar = navbar
        
        if !viewModel.isHiddenProfile {
            let navbarHeaderContentView = ExpandableNavbar.HeaderContentView.ImageAndText()
            navbarHeaderContentView.title = viewModel.name
            navbarHeaderContentView.imageUrl = viewModel.avatarLink
            navbar.addHeaderContentView(navbarHeaderContentView)
        }
    }
    
    private func removeThrobberViewController() {
        throbberViewController?.removeFromParent()
        throbberViewController?.view.removeFromSuperview()
        throbberViewController = nil
    }
}

extension ProfileViewController: ProfileViewInput {
    
    func showLoader() {
        let throbberViewController = ThrobberViewController()
        self.throbberViewController = throbberViewController
        addChild(throbberViewController)
        view.addSubview(throbberViewController.view)
        throbberViewController.view.snp.pinToAllSuperviewEdges()
    }
    
    func showData(viewModel: ProfileViewModel) {
        removeThrobberViewController()
        if viewModel.isHiddenProfile {
            addNavbar(viewModel: viewModel)
            addHiddenProfileLabel()
        } else {
            addOwnedGamesViewController(viewModel: viewModel)
            addNavbar(viewModel: viewModel)
        }
    }
}
