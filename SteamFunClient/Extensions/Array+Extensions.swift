//
//  Array+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

public extension Array {
    
    subscript(safe index: Index) -> Element? {
        return (startIndex..<endIndex) ~= index ? self[index] : nil
    }
}
