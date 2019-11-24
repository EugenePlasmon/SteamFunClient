//
//  SteamAuthViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 24.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

protocol SteamAuthViewInput: class {
    
    func openLink(_ link: String)
    
    func stopWebViewActivity()
}

protocol SteamAuthViewOutput: class {
    
    func viewDidLoad()
    
    func webViewDidReceive(navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void)
}

final class SteamAuthViewController: UIViewController {
    
    private let output: SteamAuthViewOutput
    
    private let webView = WKWebView()
    private let throbber = UIActivityIndicatorView()
    
    // MARK: - Init
    
    init(output: SteamAuthViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        output.viewDidLoad()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        self.view.backgroundColor = .white
        addWebView()
        addThrobber()
    }
    
    private func addWebView() {
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.top.bottom.left.right.equalTo(view) }
    }
    
    private func addThrobber() {
        view.addSubview(throbber)
        throbber.snp.makeConstraints { $0.center.equalTo(view) }
    }
}

// MARK: - SteamAuthViewInput

extension SteamAuthViewController: SteamAuthViewInput {
    
    func openLink(_ link: String) {
        guard let url = URL(string: link) else { return }
        webView.isHidden = false
        let request = URLRequest(url: url)
        webView.load(request)
        throbber.startAnimating()
    }
    
    func stopWebViewActivity() {
        webView.stopLoading()
        webView.isHidden = true
    }
}

// MARK: - WKNavigationDelegate

extension SteamAuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if throbber.isAnimating {
            throbber.stopAnimating()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        output.webViewDidReceive(navigationResponse: navigationResponse, decisionHandler: decisionHandler)
    }
}
