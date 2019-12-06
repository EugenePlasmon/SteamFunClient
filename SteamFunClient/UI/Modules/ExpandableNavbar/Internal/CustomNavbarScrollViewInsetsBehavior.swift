//
//  CustomNavbarScrollViewInsetsBehavior.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

/// Протокол для поддержки задания кастомных инсетов скролл-вью для того, чтобы учитывался размер навбара.
internal protocol CustomNavbarScrollViewInsetsBehavior {
    
    /// Скролл вью, для которой применяются инсеты, учитывающие размер навбара.
    var scrollView: UIScrollView? { get }
    
    /// Следует ли в инсетах скролл вью учесть высоту навбара.
    /// По дефолту `true`.
    var shouldExtendScrollViewInsetWithNavbarHeight: Bool { get }
    
    /// Кастомные инсеты для скролл вью, которые будут прибавлены к минимально необходимым инсетам, учитывающим размер навбара.
    var scrollViewInsets: UIEdgeInsets { get set }
    
    /// Максимально возможная высота навбара.
    var maximumHeight: CGFloat { get }
    
    /// Метод, задающий инсеты скролл вьюхе.
    func updateScrollViewInsets()
}

/// Дефолтная реализация метода, задающего инсеты.
extension CustomNavbarScrollViewInsetsBehavior {
    
    var shouldExtendScrollViewInsetWithNavbarHeight: Bool {
        return true
    }
    
    func updateScrollViewInsets() {
        guard let scrollView = self.scrollView else {
            return
        }
        let insets = self.scrollViewInsets
        let additionalInsetTop = self.shouldExtendScrollViewInsetWithNavbarHeight
            ? self.maximumHeight
            : 0.0
        scrollView.contentInset = UIEdgeInsets(top: insets.top + additionalInsetTop,
                                               left: insets.left,
                                               bottom: insets.bottom,
                                               right: insets.right)
    }
}
