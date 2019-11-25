//
//  ThrobberViewController.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 27.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import SnapKit

final class ThrobberViewController: UIViewController {
    
    private let bar = UIView()
    private let throbber = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = FeatureColor.Throbber.background
        bar.backgroundColor = FeatureColor.Throbber.barBackground
        
        view.addSubview(bar)
        view.addSubview(throbber)
        
        bar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(UIApplication.shared.statusBarHeight)
        }
        
        throbber.snp.centerInSuperview()
        throbber.startAnimating()
    }
}
