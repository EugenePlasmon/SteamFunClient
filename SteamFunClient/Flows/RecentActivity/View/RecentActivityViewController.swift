//
//  RecentActivityViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class RecentActivityViewController: UIViewController {
    
    private let output: RecentActivityViewOutput
    
    private var throbberViewController: ThrobberViewController?
    private var navbar: ExpandableNavbar?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(RecentActivityGameCell.self, forCellReuseIdentifier: RecentActivityGameCell.reuseIdentifier)
        return tableView
    }()
    
    private var games: [Game] = []
    
    init(output: RecentActivityViewOutput) {
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
        view.backgroundColor = FeatureColor.RecentActivity.background
        navigationController?.isNavigationBarHidden = true
    }
    
    private func addNavbar() {
        let navbar = ExpandableNavbar(scrollView: tableView, config: defaultNavbarConfig)
        self.navbar = navbar
        
        let navbarHeaderContentView = ExpandableNavbar.HeaderContentView.Text()
        navbarHeaderContentView.title = "Недавняя активность"
        
        addChild(navbar)
        view.addSubview(navbar.view)
        navbar.view.snp.makeConstraints { $0.top.left.right.equalToSuperview() }
        navbar.addHeaderContentView(navbarHeaderContentView)
    }
    
    private func addTableView() {
        view.addSubview(tableView)
        tableView.snp.pinToAllSuperviewEdges()
    }
    
    private func removeThrobberViewController() {
        throbberViewController?.removeFromParent()
        throbberViewController?.view.removeFromSuperview()
        throbberViewController = nil
    }
}

extension RecentActivityViewController: RecentActivityViewInput {
    
    func showLoader() {
        let throbberViewController = ThrobberViewController()
        self.throbberViewController = throbberViewController
        addChild(throbberViewController)
        view.addSubview(throbberViewController.view)
        throbberViewController.view.snp.pinToAllSuperviewEdges()
    }
    
    func showData(_ games: [Game]) {
        removeThrobberViewController()
        self.games = games
        addTableView()
        addNavbar()
    }
}

// MARK: - UITableViewDataSource

extension RecentActivityViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentActivityGameCell.reuseIdentifier, for: indexPath) as! RecentActivityGameCell
        guard let game = games[safe: indexPath.row] else { return cell }
        cell.imageUrl = game.logoUrl
        cell.title = game.name
        cell.playtime = game.playtimeTotal.hoursAndMinutes + " всего"
        cell.playtimeLastTwoWeeks = game.playtimeLastTwoWeeks.hoursAndMinutes + " за последние 2 недели"
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension RecentActivityViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
