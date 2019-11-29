//
//  FriendsViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class FriendsViewController: UIViewController {
    
    private let output: FriendsViewOutput
    
    private var throbberViewController: ThrobberViewController?
    
    private var friendsListViewController: FriendsListViewController?
    
    private let navbarConfig =
        ExpandableNavbarViewController.Config(backgroundBlurColor: .zeratul,
                                              showBackButton: true,
                                              scrollViewInsets: .init(top: 16.0, left: 0, bottom: 16.0, right: 0),
                                              hasBlur: true)
    private var navbar: ExpandableNavbarViewController?
    
    // MARK: - Init
    
    init(output: FriendsViewOutput) {
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
        view.backgroundColor = FeatureColor.Friends.background
        navigationController?.isNavigationBarHidden = true
    }
    
    private func addFriendsListViewController(viewModel: FriendsViewModel) {
        let friendsListViewController = FriendsListViewController(friends: viewModel.cells)
        friendsListViewController.onFriendSelect = { [weak self] friend in
            self?.output.viewDidSelectFriend(with: friend.steamID)
        }
        self.friendsListViewController = friendsListViewController
        addChild(friendsListViewController)
        view.addSubview(friendsListViewController.view)
        friendsListViewController.view.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            if #available(iOS 11.0, *) {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            } else {
                $0.bottom.equalToSuperview()
            }
        }
    }
    
    private func addNavbar(viewModel: FriendsViewModel) {
        let navbar = ExpandableNavbarViewController(scrollView: friendsListViewController?.tableView, config: navbarConfig)
        self.navbar = navbar
        
        let navbarHeaderContentView = ProfileNavbarHeaderContentView() // TODO: заменить
        navbarHeaderContentView.avatarUrl = viewModel.avatarLink
        navbarHeaderContentView.title = viewModel.title
        
        addChild(navbar)
        view.addSubview(navbar.view)
        navbar.view.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        navbar.addHeaderContentView(navbarHeaderContentView)
    }
    
    private func removeThrobberViewController() {
        throbberViewController?.removeFromParent()
        throbberViewController?.view.removeFromSuperview()
        throbberViewController = nil
    }
}

extension FriendsViewController: FriendsViewInput {
    
    func showLoader() {
        let throbberViewController = ThrobberViewController()
        self.throbberViewController = throbberViewController
        addChild(throbberViewController)
        view.addSubview(throbberViewController.view)
        throbberViewController.view.snp.pinToAllSuperviewEdges()
    }
    
    func showData(viewModel: FriendsViewModel) {
        removeThrobberViewController()
        addFriendsListViewController(viewModel: viewModel)
        addNavbar(viewModel: viewModel)
    }
}
