//
//  String+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

extension String {
    
    func appending(pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    func appending(pathExtension: String) -> String? {
        return (self as NSString).appendingPathExtension(pathExtension)
    }
}
