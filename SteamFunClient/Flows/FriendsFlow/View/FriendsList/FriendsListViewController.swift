//
//  FriendsListViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class FriendsListViewController: UIViewController {
    
    let cellModels: [FriendsViewModel.Cell]
    
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
        cell.avatarUrl = friend.avatarLink
        cell.name = friend.name
        cell.realName = friend.realName
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FriendsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let friend = self.cellModels[safe: indexPath.row] else {
            return
        }
        onFriendSelect?(friend)
    }
}
