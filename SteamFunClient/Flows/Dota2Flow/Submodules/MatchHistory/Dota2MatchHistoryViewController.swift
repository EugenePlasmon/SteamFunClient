//
//  Dota2MatchHistoryViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 04.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Dota2MatchHistoryViewController: UIViewController {
    
    let viewModel: Dota2ViewModel
    var onShortStatsTap: (() -> Void)?
    var onScrollViewDidScroll: ((UIScrollView) -> Void)?
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(Dota2ShortStatsCell.self, forCellReuseIdentifier: Dota2ShortStatsCell.reuseIdentifier)
        tableView.register(Dota2MatchCell.self, forCellReuseIdentifier: Dota2MatchCell.reuseIdentifier)
        return tableView
    }()
    
    // MARK: - Init
    
    init(viewModel: Dota2ViewModel) {
        self.viewModel = viewModel
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

// MARK: - CellType

extension Dota2MatchHistoryViewController {
    
    enum CellType: CaseIterable {
        case shortStats
        case emptySpaceForScrollableHeader
        case match
        
        init(indexPath: IndexPath) {
            switch indexPath.row {
            case 0: self = .shortStats
            case 1: self = .emptySpaceForScrollableHeader
            default: self = .match
            }
        }
        
        var cellHeight: CGFloat {
            switch self {
            case .shortStats: return 142.0
            case .emptySpaceForScrollableHeader: return 69.0
            case .match: return 82.0
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension Dota2MatchHistoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = CellType(indexPath: indexPath)
        switch type {
        case .shortStats:
            let cell = tableView.dequeueReusableCell(withIdentifier: Dota2ShortStatsCell.reuseIdentifier, for: indexPath) as! Dota2ShortStatsCell
            cell.viewModel = viewModel.shortStats
            cell.selectionStyle = .none
            return cell
        case .emptySpaceForScrollableHeader:
            return UITableViewCell()
        case .match:
            let cell = tableView.dequeueReusableCell(withIdentifier: Dota2MatchCell.reuseIdentifier, for: indexPath) as! Dota2MatchCell
            guard let match = match(for: indexPath) else {
                return cell
            }
            configure(cell, with: match)
            return cell
        }
    }
    
    private func cellsCount(for type: CellType) -> Int {
        switch type {
        case .shortStats:
            return 1
        case .emptySpaceForScrollableHeader:
            return 1
        case .match:
            return viewModel.matches.count
        }
    }
    
    private var cellsCount: Int {
        return CellType.allCases.reduce(0) { $0 + cellsCount(for: $1) }
    }
    
    private func match(for indexPath: IndexPath) -> Dota2ViewModel.Match? {
        let shift = cellsCount(for: .shortStats) + cellsCount(for: .emptySpaceForScrollableHeader)
        return viewModel.matches[safe: indexPath.row - shift]
    }
}

// MARK: - UITableViewDelegate

extension Dota2MatchHistoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = CellType(indexPath: indexPath)
        return type.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = CellType(indexPath: indexPath)
        switch type {
        case .shortStats:
            onShortStatsTap?()
        case .emptySpaceForScrollableHeader:
            return
        case .match:
            /// Пока не обрабатываем нажатие на ячейку.
            /// В readme.md описаны продуктовые планы по обработке этого нажатия.
            return
        }
    }
}

// MARK: - UIScrollViewDelegate

extension Dota2MatchHistoryViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        onScrollViewDidScroll?(scrollView)
    }
}
