//
//  UIColor+Initializers.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

/// Создает объект UIColor из переданных параметров согласно цветовой схеме rgb
///
/// - Parameters:
///   - red: Число от `0` до `255`, интенсивность красного цвета
///   - green: Число от `0` до `255`, интенсивность зеленого цвета
///   - blue: Число от `0` до `255`, интенсивность синего цвета
/// - Returns: Объект UIColor
func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
    return rgba(red, green, blue, 1.0)
}

/// Создает объект UIColor из переданных параметров согласно цветовой схеме rgb. Содержит параметр `a`, отвечающий за непрозрачность
///
/// - Parameters:
///   - red: Число от `0` до `255`, интенсивность красного цвета
///   - green: Число от `0` до `255`, интенсивность зеленого цвета
///   - blue: Число от `0` до `255`, интенсивность синего цвета
///   - alpha: Число от `0` до `1`, непрозрачность. Значение `0` соответствует полностью прозрачному цвету, `1` - полностью непрозрачному.
/// - Returns: Объект UIColor
func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
    return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
}
