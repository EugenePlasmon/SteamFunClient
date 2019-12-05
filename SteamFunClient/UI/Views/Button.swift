//
//  Button.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Button: UIButton {
    
    typealias OnTapClosure = () -> Void
    
    var onTap: OnTapClosure?
    
    // MARK: - Init
    
    init(onTap: OnTapClosure? = nil) {
        super.init(frame: .zero)
        self.onTap = onTap
        self.configureSelectors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func configureSelectors() {
        self.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc private func didTap() {
        onTap?()
    }
}
