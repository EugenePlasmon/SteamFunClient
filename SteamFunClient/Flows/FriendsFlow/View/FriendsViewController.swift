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
    
    private var navbar: ExpandableNavbar?
    
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
            $0.toSuperviewBottomSafeArea(from: self)
        }
    }
    
    private func addNavbar(viewModel: FriendsViewModel) {
        let navbar = ExpandableNavbar(scrollView: friendsListViewController?.tableView, config: defaultNavbarConfig)
        self.navbar = navbar
        
        let navbarHeaderContentView = ExpandableNavbar.HeaderContentView.ImageAndText()
        navbarHeaderContentView.imageUrl = viewModel.avatarLink
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
    
    func showData(viewModel: FriendsViewModel) {
        removeThrobberViewController()
        addFriendsListViewController(viewModel: viewModel)
        addNavbar(viewModel: viewModel)
    }
    
    func updateCellsData(cells: [FriendsViewModel.Cell], updatedAt index: Int) {
        self.friendsListViewController?.updateCellsData(cells: cells, updatedAt: index)
    }
}
