//
//  CGPoint+Extensions.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 07.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension CGPoint {
    
    func distance(to point: CGPoint) -> CGFloat {
        let diffX = x - point.x
        let diffY = y - point.y
        return sqrt(diffX * diffX + diffY * diffY)
    }
}
