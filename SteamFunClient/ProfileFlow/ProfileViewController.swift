//
//  ProfileViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import Kingfisher

protocol ProfileViewInput: class {
    
    // TODO:
    func show(name: String, realName: String, avatarLink: String)
    
    func show(games: [Game])
}

protocol ProfileViewOutput: class {
    
    func viewDidLoad()
    
    func viewDidTapLogout()
}


final class ProfileViewController: UIViewController {
    
    private let output: ProfileViewOutput
    
    // MARK: - Views
    
    private let avatar = UIImageView()
    private let nameLabel = UILabel()
    private let realNameLabel = UILabel()
    private lazy var logoutButton = Button { [weak self] in
        self?.output.viewDidTapLogout()
    }
    
    // MARK: - Init
    
    init(output: ProfileViewOutput) {
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
    
    // TODO:
    private func configureUI() {
        view.backgroundColor = .white
        addSubviews()
        makeAvatarConstraints()
        makeNameLabelConstraints()
        makeRealNameLabelConstraints()
        makeLogoutButtonConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(avatar)
        view.addSubview(nameLabel)
        view.addSubview(realNameLabel)
        view.addSubview(logoutButton)
        
        nameLabel.numberOfLines = 0
        realNameLabel.numberOfLines = 0
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.setTitleColor(.systemBlue, for: .normal)
    }
    
    private func makeAvatarConstraints() {
        avatar.snp.makeConstraints {
            $0.left.equalTo(view).offset(16.0)
            $0.top.equalTo(view).offset(116.0)
            $0.width.height.equalTo(100.0)
        }
    }
    
    private func makeNameLabelConstraints() {
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(avatar.snp.top)
            $0.left.equalTo(avatar.snp.right).offset(16.0)
            $0.right.equalTo(logoutButton.snp.left).offset(-8.0)
        }
    }
    
    private func makeRealNameLabelConstraints() {
        realNameLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel).offset(16.0)
            $0.left.equalTo(avatar.snp.right).offset(16.0)
            $0.right.equalToSuperview().offset(-16.0)
        }
    }
    
    private func makeLogoutButtonConstraints() {
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(avatar.snp.top)
            $0.right.equalToSuperview().offset(-16.0)
        }
    }
}

extension ProfileViewController: ProfileViewInput {
    
    func show(name: String, realName: String, avatarLink: String) {
        self.nameLabel.text = name
        self.realNameLabel.text = realName
        self.avatar.kf.setImage(with: URL(string: avatarLink))
    }
    
    func show(games: [Game]) {
        let gamesViewController = OwnedGamesViewController(games: games)
        self.addChild(gamesViewController)
        view.addSubview(gamesViewController.view)
        gamesViewController.view.snp.makeConstraints {
            $0.top.equalTo(avatar.snp.bottom).offset(16.0)
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
