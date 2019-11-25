//
//  UIApplication+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public extension UIApplication {
    
    /// Высота статус бара для данного девайса.
    /// Лучше использовать это свойства вместо `statusBarFrame.height`, так как при скрытом статус-баре последнее вернет `0`.
    var statusBarHeight: CGFloat {
        let statusBarDefaultHeight: CGFloat = 20.0
        var statusBarHeight: CGFloat = statusBarDefaultHeight
        if #available(iOS 11.0, *) {
            if let safeAreaInsetTop = UIApplication.shared.keyWindow?.safeAreaInsets.top
                , safeAreaInsetTop > 0 {
                statusBarHeight = safeAreaInsetTop
            }
        }
        return statusBarHeight
    }
}
