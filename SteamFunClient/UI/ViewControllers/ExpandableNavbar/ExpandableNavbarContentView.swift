//
//  ExpandableNavbarContentView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

/// Внутренний протокол IVIUIKit`а для сообщения навбару о том, что на контент вью обновился лэйаут.
internal protocol ExpandableNavbarContentViewOutput: class {
    
    /// Сообщает, что на вью обновился лэйаут.
    func contentViewDidLayoutSubviews()
}

/// Сабклассы этой вью должны быть добавлены как content view в кастомный навбар `ExpandableNavbarViewController`.
open class ExpandableNavbarContentView: UIView {
    
    /// Инстанс кастомного навбара, он будет ловить событие о том, что на вью обновился лэйаут.
    internal weak var output: ExpandableNavbarContentViewOutput?
    
    /// После того, как на вью обновится лэйаут, кастомный навбар сделает соответствующие изменения в UI.
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.output?.contentViewDidLayoutSubviews()
    }
}
