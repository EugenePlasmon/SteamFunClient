//
//  OwnedGamesViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import SnapKit

final class OwnedGamesViewController: UIViewController {
    
    struct HeaderModel {
        let title: String
    }
    
    let games: [OwnedGame]
    
    private var headers: [HeaderModel] = [.init(title: "Купленные игры")]
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(OwnedGamesCell.self, forCellReuseIdentifier: OwnedGamesCell.reuseIdentifier)
        tableView.register(OwnedGamesHeaderCell.self, forCellReuseIdentifier: OwnedGamesHeaderCell.reuseIdentifier)
        return tableView
    }()
    
    weak var navbar: ExpandableNavbarViewController?
    
    typealias OnGameSelectClosure = (OwnedGame) -> Void
    var onGameSelect: OnGameSelectClosure?
    
    // MARK: - Init
    
    init(games: [OwnedGame]) {
        self.games = games
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.separatorStyle = .none
        tableView.indicatorStyle = .white
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.left.top.bottom.right.equalToSuperview() }
    }
}

// MARK: - UITableViewDataSource

extension OwnedGamesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headers.count + games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let header = tableView.dequeueReusableCell(withIdentifier: OwnedGamesHeaderCell.reuseIdentifier, for: indexPath) as! OwnedGamesHeaderCell
            header.title = "Купленные игры"
            header.selectionStyle = .none
            return header
        case let row:
            let index = row - 1
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnedGamesCell.reuseIdentifier, for: indexPath) as! OwnedGamesCell
            guard let game = games[safe: index] else {
                return cell
            }
            cell.imageUrl = game.logoUrl
            cell.title = game.name
            cell.playtime = game.playtimeTotal.hoursAndMinutes + " в игре"
            cell.selectionStyle = .none
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension OwnedGamesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = self.games[safe: indexPath.row] else {
            return
        }
        onGameSelect?(game)
    }
}

extension OwnedGamesViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navbar?.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        navbar?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
