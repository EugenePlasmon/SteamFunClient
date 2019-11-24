//
//  Monads.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

// MARK: >>-

precedencegroup MonadicPrecedence {
    associativity: left
    higherThan: BitwiseShiftPrecedence
}

infix operator >>- : MonadicPrecedence

/// В случае если значение "a" типа T существует, то будет выполнен метод f, возвращающий тип U
/// Иначе получим nil
@inline(__always)
@discardableResult
public func >>-<T, U>(a: T?, f: (T) throws -> U?) rethrows -> U? {
    switch a {
    case .some(let x):
        return try f(x)
    case .none:
        return nil
    }
}

// MARK: <<< / >>>

precedencegroup FunctionApplicationPrecedenceRight {
    lowerThan: AssignmentPrecedence
    associativity: right
}

precedencegroup FunctionApplicationPrecedenceLeft {
    lowerThan: AssignmentPrecedence
    associativity: left
}

infix operator <<< : FunctionApplicationPrecedenceRight

/// Вызывает функцию f (с левой стороны от оператора) со значением
/// x(с правой стороны от оператора) с наименьшим приоритетом
/// foo <<< x
@inline(__always)
public func <<<<T, U>(f: (T) throws -> U, x: T) rethrows -> U {
    return try f(x)
}

infix operator >>> : FunctionApplicationPrecedenceLeft

/// Вызывает функцию f (с правой  стороны от оператора) со значением
/// x(с левой стороны от оператора) с наименьшим приоритетом
/// x >>> foo
@inline(__always)
public func >>><T, U>(x: T, f: (T) throws -> U) rethrows -> U {
    return try f(x)
}
