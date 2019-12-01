//
//  RecentActivityViewInterface.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 01.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

protocol RecentActivityViewInput: class {
    
    func showLoader()
    
    func showData(_ games: [Game])
}

protocol RecentActivityViewOutput: class {
    
    func viewDidLoad()
}
