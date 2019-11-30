//
//  OwnedGamesHeaderCell.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class OwnedGamesHeaderCell: UITableViewCell {
    
    static let reuseIdentifier = "OwnedGamesHeaderCellReuseIdentifier"
    
    var title: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    private lazy var label = UILabel(color: FeatureColor.Profile.gamesListTitle,
                                     font: .stukov)
    
    // MARK: - INit
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(label)
        label.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16.0)
            $0.right.equalToSuperview().offset(-16.0)
            $0.top.equalToSuperview().offset(12.0)
            $0.bottom.equalToSuperview().offset(-8.0)
        }
    }
}
