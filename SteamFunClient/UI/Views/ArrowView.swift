//
//  ArrowView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 28.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func createNavigationBackButton() -> ArrowView? {
        guard self.viewControllers.count > 1 else { return nil }
        return ArrowView(insets: .init(top: 8.0, left: 12.0, bottom: 8.0, right: 12.0)) { [weak self] in
            self?.popViewController(animated: true)
        }
    }
}

final class ArrowView: UIControl {
    
    enum Direction {
        case up
        case down
        case left
        case right
    }
    
    var direction: Direction {
        didSet { setNeedsDisplay() }
    }
    
    var color: UIColor {
        didSet { setNeedsDisplay() }
    }
    
    var insets: UIEdgeInsets {
        didSet { setNeedsDisplay() }
    }
    
    var onTap: (() -> Void)?
    
    init(direction: Direction = .left, color: UIColor = .artanis, insets: UIEdgeInsets = .zero, onTap: (() -> Void)? = nil) {
        self.direction = direction
        self.color = color
        self.insets = insets
        self.onTap = onTap
        super.init(frame: .zero)
        isOpaque = false
        backgroundColor = .clear
        configureActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        let width = rect.width - insets.left - insets.right
        let minX = insets.left + rect.minX
        let midX = minX + width / 2
        let maxX = minX + width
        let height = rect.height - insets.top - insets.bottom
        let minY = insets.bottom + rect.minY
        let midY = minY + height / 2
        let maxY = minY + height
        let pointA: CGPoint
        let pointB: CGPoint
        let pointC: CGPoint
        switch direction {
        case .up:
            pointA = CGPoint(x: minX, y: minY)
            pointB = CGPoint(x: midX, y: maxY)
            pointC = CGPoint(x: maxX, y: minY)
        case .down:
            pointA = CGPoint(x: minX, y: maxY)
            pointB = CGPoint(x: midX, y: minY)
            pointC = CGPoint(x: maxX, y: maxY)
        case .left:
            pointA = CGPoint(x: maxX, y: minY)
            pointB = CGPoint(x: minX, y: midY)
            pointC = CGPoint(x: maxX, y: maxY)
        case .right:
            pointA = CGPoint(x: minX, y: minY)
            pointB = CGPoint(x: maxX, y: midY)
            pointC = CGPoint(x: minX, y: minY)
        }
        context.move(to: pointA)
        context.addLine(to: pointB)
        context.addLine(to: pointC)
        context.setLineWidth(3.0)
        let color = isHighlighted ? self.color.darken(by: 0.2) : self.color
        context.setStrokeColor(color.cgColor)
        context.setLineCap(.square)
        context.strokePath()
    }
    
    override var isHighlighted: Bool {
        didSet { setNeedsDisplay() }
    }
    
    private func configureActions() {
        addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    @objc func didTap() {
        onTap?()
    }
}
