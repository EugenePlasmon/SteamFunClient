//
//  ExpandableNavbarContentView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension ExpandableNavbar {
    
    /// Сабклассы этой вью должны быть добавлены как content view в кастомный навбар `ExpandableNavbar`.
    open class ContentView: UIView {
        
        /// Инстанс кастомного навбара будет ловить событие о том, что на вью обновился лэйаут.
        internal final var onLayoutSubviews: (() -> Void)?
        
        /// После того, как на вью обновится лэйаут, кастомный навбар сделает соответствующие изменения в UI.
        open override func layoutSubviews() {
            super.layoutSubviews()
            onLayoutSubviews?()
        }
    }
}


