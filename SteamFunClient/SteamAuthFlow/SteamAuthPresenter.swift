//
//  SteamAuthPresenter.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import Foundation
import WebKit

final class SteamAuthPresenter {
    
    weak var viewInput: (UIViewController & SteamAuthViewInput)?
    
    private let onFlowFinish: SteamAuthModuleBuilder.OnFlowFinishClosure
    
    init(onFlowFinish: @escaping SteamAuthModuleBuilder.OnFlowFinishClosure) {
        self.onFlowFinish = onFlowFinish
    }
}

extension SteamAuthPresenter: SteamAuthViewOutput {
    
    func viewDidLoad() {
        viewInput?.openLink(Steam.authPageLink)
    }
    
    func webViewDidReceive(navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let action: WKNavigationResponsePolicy
        defer {
            decisionHandler(action)
        }
        guard let url = navigationResponse.response.url else {
            action = .cancel
            return
        }
        action = .allow
        
        if let steamID = self.extractSteamID(from: url) {
            self.viewInput?.stopWebViewActivity()
            onFlowFinish(.success(steamID))
        }
    }
    
    private func extractSteamID(from url: URL) -> SteamID? {
        guard url.absoluteString.hasPrefix(Steam.profileLinkPrefix) else {
            return nil
        }
        let components = url.absoluteString.components(separatedBy: "/")
        return components.enumerated()
            .first { $0.element == "profiles" }
            >>- { components[safe: $0.offset + 1] }
            >>- SteamID.init
    }
}
