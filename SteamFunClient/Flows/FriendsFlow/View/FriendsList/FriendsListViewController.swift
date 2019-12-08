//
//  FriendsListViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class FriendsListViewController: UIViewController {
    
    private(set) var cellModels: [FriendsViewModel.Cell]
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FriendsListCell.self, forCellReuseIdentifier: FriendsListCell.reuseIdentifier)
        return tableView
    }()
    
    typealias OnFriendSelectClosure = (FriendsViewModel.Cell) -> Void
    var onFriendSelect: OnFriendSelectClosure?
    
    // MARK: - Init
    
    init(friends: [FriendsViewModel.Cell]) {
        self.cellModels = friends
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
        tableView.estimatedRowHeight = 68.0
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { $0.left.top.bottom.right.equalToSuperview() }
    }
    
    func updateCellsData(cells: [FriendsViewModel.Cell], updatedAt index: Int) {
        self.cellModels = cells
        
        let indexPath = IndexPath(row: index, section: 0)
        guard let contains = tableView.indexPathsForVisibleRows?.contains(indexPath)
            , contains
            , let cell = tableView.cellForRow(at: indexPath) as? FriendsListCell
            , let friend = cells[safe: indexPath.row] else {
                return
        }
        configure(cell, with: friend)
    }
    
    private func configure(_ cell: FriendsListCell, with friend: FriendsViewModel.Cell) {
        switch friend.state {
        case .loading:
            cell.isLoading = true
        case .data(let name, let realName, let avatarLink):
            cell.isLoading = false
            cell.avatarUrl = avatarLink
            cell.name = name
            cell.realName = realName
        case .error:
            cell.isLoading = false
            cell.name = "Произошла ошибка"
        }
        cell.selectionStyle = .none
    }
}

// MARK: - UITableViewDataSource

extension FriendsListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsListCell.reuseIdentifier, for: indexPath) as! FriendsListCell
        guard let friend = cellModels[safe: indexPath.row] else {
            return cell
        }
        configure(cell, with: friend)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FriendsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let friend = self.cellModels[safe: indexPath.row] else { return }
        onFriendSelect?(friend)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellModel = self.cellModels[safe: indexPath.row] else { return }
        cellModel.onWillDisplay(cellModel)
    }
}
