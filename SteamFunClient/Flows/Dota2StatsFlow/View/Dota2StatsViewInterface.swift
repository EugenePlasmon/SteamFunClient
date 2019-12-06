//
//  Dota2StatsViewInterface.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

protocol Dota2StatsViewInput: class {
    
    func addNavbar(imageUrl: String?, title: String)
    
    func addPlot(_ plotView: Plot)
    
    func addTopHeroesBlock(with viewController: UIViewController)
}


protocol Dota2StatsViewOutput: class {
    
    func viewDidLoad()
}
