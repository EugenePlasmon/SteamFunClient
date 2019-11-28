//
//  UIColor+Initializers.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public extension UIColor {
    
    /// Создает объект UIColor из переданных параметров согласно цветовой схеме rgb
    ///
    /// - Parameters:
    ///   - red: Число от `0` до `255`, интенсивность красного цвета
    ///   - green: Число от `0` до `255`, интенсивность зеленого цвета
    ///   - blue: Число от `0` до `255`, интенсивность синего цвета
    /// - Returns: Объект UIColor
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
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
    static func rgba(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    func darken(by: CGFloat) -> UIColor {
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return .init(hue: hue, saturation: saturation, brightness: max(brightness - by, 0), alpha: alpha)
    }
}

//+ (UIColor *)colorDarkerBy:(CGFloat)darkerBy dimmerBy:(CGFloat)dimmerBy fromColor:(UIColor *)color
//{
//    CGFloat h, s, b, a;
//
//    if ([color getHue:&h saturation:&s brightness:&b alpha:&a])
//    {
//        return [UIColor colorWithHue:h
//                          saturation:MAX(s - dimmerBy, 0.0f)
//                          brightness:MAX(b - darkerBy, 0.0f)
//                               alpha:a];
//    }
//
//    return color;
//}
//
//+ (UIColor *)colorBrighterBy:(CGFloat)brighterBy dimmerBy:(CGFloat)dimmerBy fromColor:(UIColor *)color
//{
//    CGFloat h, s, b, a;
//
//    if ([color getHue:&h saturation:&s brightness:&b alpha:&a])
//    {
//        return [UIColor colorWithHue:h
//                          saturation:MAX(s - dimmerBy, 0.0f)
//                          brightness:MIN(1.0f, b + brighterBy)
//                               alpha:a];
//    }
//
//    return color;
//}
