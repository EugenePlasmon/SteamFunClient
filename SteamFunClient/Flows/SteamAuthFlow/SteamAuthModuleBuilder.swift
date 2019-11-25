//
//  SteamAuthAssembly.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation

final class SteamAuthModuleBuilder {
    
    typealias OnFlowFinishClosure = (Result<SteamID, Error>) -> Void
    
    static func build(onFlowFinish: @escaping OnFlowFinishClosure) -> SteamAuthViewController {
        let presenter = SteamAuthPresenter(onFlowFinish: onFlowFinish)
        let viewController = SteamAuthViewController(output: presenter)
        presenter.viewInput = viewController
        
        return viewController
    }
}
