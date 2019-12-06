//
//  CustomNavbarSnappingBehavior.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

/// Протокол для поддержки snapping поведения навбаром,
/// который может находиться в развернутом (expanded) и свернутом (collapsed) состоянии.
/// (snapping поведение - автоматическое доскралливание до развернутого или свернутого состояния.)
internal protocol CustomNavbarSnappingBehavior {
    
    /// Максимальная высота навбара (т.е. в развернутом состоянии).
    var maximumHeight: CGFloat { get }
    
    /// Минимальная высота навбара (т.е. в свернутом состоянии).
    var minimumHeight: CGFloat { get }
    
    /// Метод, который обрабатывает скролл и при необходимости доскраливает навбар до развернутого или свернутого состояния.
    func snapScrollView(_ scrollView: UIScrollView, targetContentOffset: UnsafeMutablePointer<CGPoint>)
}

/// Дефолтная реализация snapping.
extension CustomNavbarSnappingBehavior {
    
    func snapScrollView(_ scrollView: UIScrollView, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let expandedBarOffsetY = -scrollView.contentInset.top
        let collapsedBarOffsetY = expandedBarOffsetY + (self.maximumHeight - self.minimumHeight)
        let targetOffsetY = targetContentOffset.pointee.y
        
        if targetOffsetY >= expandedBarOffsetY, targetOffsetY <= collapsedBarOffsetY {
            if abs(targetOffsetY - expandedBarOffsetY) < abs(targetOffsetY - collapsedBarOffsetY) {
                targetContentOffset.pointee = CGPoint(x: 0.0, y: expandedBarOffsetY)
            } else {
                targetContentOffset.pointee = CGPoint(x: 0.0, y: collapsedBarOffsetY)
            }
        }
    }
}
