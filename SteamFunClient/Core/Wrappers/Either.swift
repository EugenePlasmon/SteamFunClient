//
//  Either.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 08.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

/// Обертка, позволяющая в виде типа `Either<T, U>` хранить объект, тип которого либо `T`, либо `U`
public enum Either<T, U> {
    case firstType(T)
    case secondType(U)
    
    /// Вытаскивает объект из обертки
    ///
    /// - Returns: Объект типа либо `T`, либо `U`, хранившийся в обертке `Either`
    public func unwrap() -> Any {
        switch self {
        case .firstType(let objectOfTypeT): return objectOfTypeT
        case .secondType(let objectOfTypeU): return objectOfTypeU
        }
    }
    
    /// Конвертит содержащиеся в Either значения в один общий тип данных V.
    ///
    /// - Parameters:
    ///   - firstTypeTransform: Кложура для конвертирования первого типа данных в V.
    ///   - secondTypeTransform: Кложура для конвертирования второго типа данных в V.
    /// - Returns: Объект типа V.
    public func map<V>(firstTypeTransform: (T) -> V, secondTypeTransform: (U) -> V) -> V {
        switch self {
        case .firstType(let value):
            return firstTypeTransform(value)
        case .secondType(let value):
            return secondTypeTransform(value)
        }
    }

}

// MARK: - Equatable

extension Either: Equatable where T: Equatable, U: Equatable {
    
    public static func == (lhs: Either<T, U>, rhs: Either<T, U>) -> Bool {
        switch (lhs, rhs) {
        case (.firstType(let lhsValue), .firstType(let rhsValue)):
            return lhsValue == rhsValue
        case (.secondType(let lhsValue), .secondType(let rhsValue)):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
    
}

// MARK: - Decodable

extension Either: Decodable where T: Decodable, U: Decodable {
    
    /// Если типы `T` и `U` конформят `Decodable`, то `Either<T, U>` тоже конформит `Decodable`
    /// При этом он сначала пытается декодировать данные в модель с типом `T`, если не получилось, то в модель с типом `U`.
    /// Если не получилось декодировать ни в один тип, то из инициализатора выбрасывается ошибка
    public init(from decoder: Decoder) throws {
        if let value = try? T(from: decoder) {
            self = .firstType(value)
        } else if let value = try? U(from: decoder) {
            self = .secondType(value)
        } else {
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription:
                "Cannot decode \(T.self) or \(U.self)")
            throw DecodingError.dataCorrupted(context)
        }
    }
    
}
