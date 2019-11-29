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
    
    private var ownedGamesViewController: OwnedGamesViewController?
    
    private lazy var navbarConfig =
        ExpandableNavbarViewController.Config(backgroundBlurColor: .zeratul,
                                              showBackButton: showBackButton,
                                              hasBlur: true)
    private var showBackButton: Bool {
        return self.navigationController >>- { $0.viewControllers.count > 1 } ?? false
    }
    private var navbar: ExpandableNavbarViewController?
    private var navbarContentView: ProfileNavbarContentView?
    private var navbarHeaderContentView: ProfileNavbarHeaderContentView?
    
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
        let ownedGamesViewController = OwnedGamesViewController(games: viewModel.ownedGames)
        self.ownedGamesViewController = ownedGamesViewController
        addChild(ownedGamesViewController)
        view.addSubview(ownedGamesViewController.view)
        ownedGamesViewController.view.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    private func addNavbar(viewModel: ProfileViewModel) {
        let navbar = ExpandableNavbarViewController(scrollView: ownedGamesViewController?.tableView, config: navbarConfig)
        let navbarContentView = ProfileNavbarContentView(viewModel: viewModel)
        navbarContentView.onActionButtonTap = { [weak self] type in
            if case .friends = type {
                self?.output.viewDidTapFriends()
            }
        }
        
        self.navbar = navbar
        self.navbarContentView = navbarContentView
        
        let navbarHeaderContentView = ProfileNavbarHeaderContentView()
        navbarHeaderContentView.title = viewModel.name
        navbarHeaderContentView.avatarUrl = viewModel.avatarLink
        
        addChild(navbar)
        view.addSubview(navbar.view)
        navbar.view.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        navbar.addContentView(navbarContentView)
        navbar.addHeaderContentView(navbarHeaderContentView)
        ownedGamesViewController?.navbar = navbar
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
        addOwnedGamesViewController(viewModel: viewModel)
        addNavbar(viewModel: viewModel)
    }
}
