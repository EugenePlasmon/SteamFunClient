//
//  Dota2MatchHistoryViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2MatchHistoryViewController: UIViewController {
    
    private(set) var cellModels: [Dota2ViewModel.Match]
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Dota2MatchCell.self, forCellReuseIdentifier: Dota2MatchCell.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Init
    
    init(matches: [Dota2ViewModel.Match]) {
        self.cellModels = matches
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.reloadData()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 82.0
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.left.top.bottom.right.equalToSuperview() }
    }
    
    private func configure(_ cell: Dota2MatchCell, with match: Dota2ViewModel.Match) {
        cell.hero = match.hero
        cell.team = match.team
        cell.isWin = match.isWin
        cell.date = match.date
        cell.selectionStyle = .none
    }
}

// MARK: - UITableViewDataSource

extension Dota2MatchHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Dota2MatchCell.reuseIdentifier, for: indexPath) as! Dota2MatchCell
        guard let match = cellModels[safe: indexPath.row] else {
            return cell
        }
        configure(cell, with: match)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension Dota2MatchHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
