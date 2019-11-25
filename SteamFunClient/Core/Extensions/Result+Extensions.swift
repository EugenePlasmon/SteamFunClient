//
//  Result+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

extension Result {
    
    @discardableResult
    func onFailure(_ f: (Failure) -> Void) -> Result {
        if case .failure(let error) = self {
            f(error)
        }
        return self
    }
    
    @discardableResult
    func onSuccess(_ f: (Success) -> Void) -> Result {
        if case .success(let value) = self {
            f(value)
        }
        return self
    }
}
