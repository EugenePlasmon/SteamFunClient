//
//  SnapKit+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import SnapKit

extension ConstraintViewDSL {
    
    func pinToAllSuperviewEdges() {
        self.makeConstraints { $0.top.right.bottom.left.equalToSuperview() }
    }
    
    func centerInSuperview() {
        self.makeConstraints { $0.center.equalToSuperview() }
    }
}
