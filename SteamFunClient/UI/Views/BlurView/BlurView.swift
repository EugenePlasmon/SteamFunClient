//
//  BlurView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

/// Вью с эффектом блюра. Заблюрит все, что находится под этой вьюхой.
/// Имеет смысл добавлять её над контентом, который нужно заблюрить
/// (например, на модальный контроллер, который показывается со стилем .overCurrentContext или .overFullScreen).
public final class BlurView: UIVisualEffectView {
    
    /// Тоновый цвет блюра.
    public var color: UIColor {
        didSet {
            self.configureUI()
        }
    }
    
    /// Уровень прозрачности, число от 0 до 1.
    public var opacity: CGFloat {
        didSet {
            self.configureUI()
        }
    }
    
    /// Радиус размытия.
    /// Значения меньше 5.0 можно условно охарактеризовать как слабое размытие.
    /// Значения больше 10.0 - сильное.
    public var blurRadius: CGFloat {
        didSet {
            self.configureUI()
        }
    }
    
    // MARK: - Initialization
    
    /// Инициализатор вью для размытия.
    ///
    /// - Parameters:
    ///   - color: Тоновый цвет блюра.
    ///   - opacity: Уроверь прозрачности, число от 0 до 1.
    ///              По умолчанию 0.9;
    ///              большие значения не рекомендуются, так как сам блюр перестанет быть видимым.
    ///   - blurRadius: Радиус блюра. По умолчанию 8.0 - не слишком сильное и не слишком слабое размытие.
    public init(color: UIColor, opacity: CGFloat = 0.9, blurRadius: CGFloat = 8.0) {
        self.color = color
        self.opacity = opacity
        self.blurRadius = blurRadius
        super.init(effect: nil)
        self.configureUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        if UIAccessibility.isReduceTransparencyEnabled {
            self.backgroundColor = tintColor.withAlphaComponent(opacity)
        } else {
            self.effect = self.blurEffect()
        }
    }
    
    // MARK: - Private
    
    private func blurEffect() -> UIBlurEffect {
        let blurEffect: UIBlurEffect
        
        let blurClassString = NSString(format: "%@%@%@%@%@", "_U", "ICust", "omBl", "urEf", "fect")
        if let blurEffectClass = NSClassFromString(blurClassString as String) as? UIBlurEffect.Type {
            blurEffect = blurEffectClass.init()
            let colorPropertyKey = "colorTint"
            if blurEffect.responds(to: Selector(colorPropertyKey)) {
                blurEffect.setValue(self.color, forKey: colorPropertyKey)
            }
            let opacityPropertyKey = "colorTintAlpha"
            if blurEffect.responds(to: Selector(opacityPropertyKey)) {
                blurEffect.setValue(self.opacity, forKey: opacityPropertyKey)
            }
            let blurRadiusPropertyKey = "blurRadius"
            if blurEffect.responds(to: Selector(blurRadiusPropertyKey)) {
                blurEffect.setValue(self.blurRadius, forKey: blurRadiusPropertyKey)
            }
        } else {
            blurEffect = UIBlurEffect(style: .dark)
        }
        return blurEffect
    }
}
