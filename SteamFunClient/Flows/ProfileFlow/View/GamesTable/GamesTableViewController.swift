//
//  GamesTableViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import SnapKit

final class GamesTableViewController: UIViewController {
    
    struct HeaderModel {
        let title: String
    }
    
    struct Dota2CellModel {
        let title: String = "Dota 2"
        let subtitle: String = "Статистика игрока"
        let backgroundImage: UIImage? = UIImage(named: "dota2Poster")
    }
    
    let ownedGames: [Game]
    let dota2Game = Dota2CellModel()
    
    private var headers: [HeaderModel] = [.init(title: "Купленные игры")]
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Dota2Cell.self, forCellReuseIdentifier: Dota2Cell.reuseIdentifier)
        tableView.register(OwnedGameCell.self, forCellReuseIdentifier: OwnedGameCell.reuseIdentifier)
        tableView.register(OwnedGamesHeaderCell.self, forCellReuseIdentifier: OwnedGamesHeaderCell.reuseIdentifier)
        return tableView
    }()
    
    weak var navbar: ExpandableNavbar?
    
    typealias OnGameSelectClosure = (Game) -> Void
    var onGameSelect: OnGameSelectClosure?
    
    // MARK: - Init
    
    init(games: [Game]) {
        self.ownedGames = games
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
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.left.top.bottom.right.equalToSuperview() }
    }
}

// MARK: - UITableViewDataSource

extension GamesTableViewController: UITableViewDataSource {
    
    private var showDotaCell: Bool { true }
    
    private var showOwnedGamesHeader: Bool { ownedGames.count > 0 ? true : false }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (showDotaCell ? 1 : 0) + (showOwnedGamesHeader ? 1 : 0) + ownedGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dotaCellIndex = showDotaCell ? 0 : nil
        let ownedGamesHeaderIndex = !showOwnedGamesHeader ? nil : (showDotaCell ? 1 : 0)
        switch indexPath.row {
        case dotaCellIndex:
            let dota2Cell = tableView.dequeueReusableCell(withIdentifier: Dota2Cell.reuseIdentifier, for: indexPath) as! Dota2Cell
            dota2Cell.backgroundImage = dota2Game.backgroundImage
            dota2Cell.title = dota2Game.title
            dota2Cell.subtitle = dota2Game.subtitle
            dota2Cell.selectionStyle = .none
            return dota2Cell
        case ownedGamesHeaderIndex:
            let header = tableView.dequeueReusableCell(withIdentifier: OwnedGamesHeaderCell.reuseIdentifier, for: indexPath) as! OwnedGamesHeaderCell
            header.title = "Купленные игры"
            header.selectionStyle = .none
            return header
        case let row:
            let index = row - (showDotaCell ? 1 : 0) - (showOwnedGamesHeader ? 1 : 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: OwnedGameCell.reuseIdentifier, for: indexPath) as! OwnedGameCell
            guard let game = ownedGames[safe: index] else {
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

extension GamesTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let game = self.ownedGames[safe: indexPath.row] else {
            return
        }
        onGameSelect?(game)
    }
}

extension GamesTableViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navbar?.scrollViewDidScroll(scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        navbar?.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
}
