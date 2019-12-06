//
//  PlotCanvas.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class PlotCanvas: UIView {
    
    private weak var dataSource: PlotDataSource?
    
    private let config: Config
    
    struct Config {
        let plotLineColor = FeatureColor.Dota2Stats.Plot.line
        let plotBackgroundColor = FeatureColor.Dota2Stats.Plot.background
        let lineWidth: CGFloat = 3.0
    }
    
    // MARK: - Init
    
    init(dataSource: PlotDataSource, config: Config = Config()) {
        self.config = config
        super.init(frame: .zero)
        self.dataSource = dataSource
        backgroundColor = config.plotBackgroundColor
        isMultipleTouchEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        /// Перевернуть систему координат
        context.saveGState()
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1, y: -1)
        defer { context.restoreGState() }
        
        drawPlot(with: context, in: rect)
    }
    
    // MARK: - Private
    
    private func drawPlot(with context: CGContext, in rect: CGRect) {
        guard let dataSource = self.dataSource else { return }
        
        let width = dataSource.endX - dataSource.startX
        let height = dataSource.endY - dataSource.startY
        let relativePoints: [CGPoint] = dataSource.points.map {
            let x = ($0.timestamp - dataSource.startX) / width
            let y = ($0.value - dataSource.startY) / height
            return CGPoint(x: x, y: y)
        }
        
        let absolutePoints: [CGPoint] = relativePoints.map {
            CGPoint(x: rect.minX + $0.x * rect.width,
                    y: rect.minY + $0.y * rect.height)
        }
        
        for (i, point) in absolutePoints.enumerated() {
            if i == 0 {
                context.move(to: point)
            } else {
                context.addLine(to: point)
            }
        }
        
        context.setLineWidth(config.lineWidth)
        context.setStrokeColor(config.plotLineColor.cgColor)
        context.strokePath()
    }
}
