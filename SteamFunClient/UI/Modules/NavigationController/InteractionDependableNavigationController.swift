//
//  InteractionDependableNavigationController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 07.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public class InteractionDependableNavigationController: UINavigationController {
    
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        isNavigationBarHidden = true
        interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: - Orientation
    
    override public var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let firstViewController = self.viewControllers.first else {
            return .all
        }
        return firstViewController.supportedInterfaceOrientations
    }
    
    // MARK: - UI
    
    /// Переопределяем метод, чтобы заново установить делегат для интерактивного жеста, когда мы скрываем навбар
    /// Без этого не будет работать интерактивный жест при скрытом навбаре
    override public func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        self.interactivePopGestureRecognizer?.delegate = self
    }
}

// MARK: - UIGestureRecognizerDelegate

extension InteractionDependableNavigationController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return self.viewControllers.count > 1
    }
}
