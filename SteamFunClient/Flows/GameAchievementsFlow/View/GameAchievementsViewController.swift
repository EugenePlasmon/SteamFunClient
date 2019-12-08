//
//  GameAchievementsViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 05.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class GameAchievementsViewController: UIViewController {
    
    private let output: GameAchievementsViewOutput
    
    private var navbar: ExpandableNavbar?
    private var throbberViewController: ThrobberViewController?
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(GameAchievementCell.self, forCellReuseIdentifier: GameAchievementCell.reuseIdentifier)
        return tableView
    }()
    
    private var viewModel: GameAchievementsViewModel?
    
    // MARK: - Init
    
    init(output: GameAchievementsViewOutput) {
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
        self.output.viewDidLoad()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = FeatureColor.Dota2.background
        navigationController?.isNavigationBarHidden = true
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.toSuperviewBottomSafeArea(from: self)
        }
        
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72.0
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func addNavbar(viewModel: GameAchievementsViewModel) {
        let navbar = ExpandableNavbar(scrollView: tableView, config: defaultNavbarConfig)
        self.navbar = navbar
        
        let navbarContentView = GameAchievementsHeaderView()
        navbarContentView.imageUrl = viewModel.header.gameLogoUrl
        navbarContentView.title = viewModel.header.gameName
        navbarContentView.progress = viewModel.header.playerProgress
        
        let navbarHeaderContentView = ExpandableNavbar.HeaderContentView.ImageAndText()
        navbarHeaderContentView.imageUrl = viewModel.header.gameIconUrl
        navbarHeaderContentView.title = viewModel.header.gameName
        
        addChild(navbar)
        view.addSubview(navbar.view)
        navbar.view.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        navbar.addContentView(navbarContentView)
        navbar.addHeaderContentView(navbarHeaderContentView)
    }
    
    // MARK: - Private
    
    private func removeThrobberViewController() {
        throbberViewController?.removeFromParent()
        throbberViewController?.view.removeFromSuperview()
        throbberViewController = nil
    }
    
    private func addEmptyNavbar() {
        let navbar = ExpandableNavbar(scrollView: tableView, config: defaultNavbarConfig)
        self.navbar = navbar
        addChild(navbar)
        view.addSubview(navbar.view)
        navbar.view.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
    }
    
    private var errorLabel: UILabel?
    
    private func addErrorLabel(message: String) {
        errorLabel = UILabel(text: message, color: FeatureColor.Achievements.errorText, font: .brakk, numberOfLines: 0, textAlignment: .center)
        errorLabel >>- view.addSubview
        errorLabel?.snp.makeConstraints {
            $0.top.equalToSuperview().offset((navbar?.minimumHeight ?? 64.0) + 24.0)
            $0.left.right.equalToSuperview().inset(16.0)
        }
    }
}

// MARK: - GameAchievementsViewInput

extension GameAchievementsViewController: GameAchievementsViewInput {
    
    func showLoader() {
        let throbberViewController = ThrobberViewController()
        self.throbberViewController = throbberViewController
        addChild(throbberViewController)
        view.addSubview(throbberViewController.view)
        throbberViewController.view.snp.pinToAllSuperviewEdges()
    }
    
    func showData(viewModel: GameAchievementsViewModel) {
        self.viewModel = viewModel
        removeThrobberViewController()
        addTableView()
        addNavbar(viewModel: viewModel)
    }
    
    func showError(message: String) {
        removeThrobberViewController()
        addEmptyNavbar()
        addErrorLabel(message: message)
    }
}

// MARK: - UITableViewDataSource

extension GameAchievementsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: GameAchievementCell.reuseIdentifier, for: indexPath) as! GameAchievementCell
        guard let cellViewModel = viewModel.cells[safe: indexPath.row] else {
            return cell
        }
        cell.imageUrl = cellViewModel.imageUrl
        cell.name = cellViewModel.hidden ? "Скрытый приз" : cellViewModel.name
        cell.globalPercentage = cellViewModel.globalPercentage
        cell.achievementDescription = cellViewModel.description
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension GameAchievementsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navbar?.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        navbar?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}

