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
    private let barBlur = BlurView(color: FeatureColor.Throbber.barBackground)
    private var arrow: ArrowView?
    private let throbber = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        arrow = self.navigationController?.createNavigationBackButton()
        
        view.backgroundColor = FeatureColor.Throbber.background
        bar.backgroundColor = .clear
        
        view.addSubview(bar)
        view.addSubview(throbber)
        bar.addSubview(barBlur)
        arrow >>- bar.addSubview
        
        bar.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(UIApplication.shared.statusBarHeight + 44.0)
        }
        
        barBlur.snp.pinToAllSuperviewEdges()
        
        arrow?.snp.makeConstraints {
            $0.left.equalToSuperview().offset(8.0)
            $0.bottom.equalToSuperview().offset(-8.0)
            $0.width.equalTo(32.0)
            $0.height.equalTo(36.0)
        }
        
        throbber.snp.centerInSuperview()
        throbber.startAnimating()
    }
}
