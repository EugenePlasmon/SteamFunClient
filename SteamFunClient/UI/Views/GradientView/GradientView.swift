//
//  GradientView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class GradientView: UIView {
    
    // MARK: - LayerClass
    
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // MARK: - Public properties
    
    public var gradient: Gradient {
        didSet { self.updateGradient() }
    }
    
    // MARK: - Init

    public init(gradient: Gradient) {
        self.gradient = gradient
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func updateGradient() {
        guard let layer = self.layer as? CAGradientLayer else {
            return
        }
        layer.startPoint = gradient.startPoint
        layer.endPoint = gradient.endPoint
        layer.colors = [gradient.startColor, gradient.endColor].map { $0.cgColor }
    }
}
