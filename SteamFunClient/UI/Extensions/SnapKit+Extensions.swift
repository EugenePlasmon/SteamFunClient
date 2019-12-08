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

extension ConstraintMaker {
    
    func toSuperviewBottomSafeArea(from viewController: UIViewController) {
        if #available(iOS 11.0, *) {
            self.bottom.equalTo(viewController.view.safeAreaLayoutGuide.snp.bottom)
        } else {
            self.bottom.equalToSuperview().inset(viewController.tabBarController?.tabBar.frame.height ?? 0.0)
        }
    }
}
