//
//  Plot.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

struct PlotModel {
    
    let points: [PlotPoint]
    let beginTimestamp: TimeInterval
    let endTimestamp: TimeInterval
}

protocol PlotDataSource: class {
    
    var startX: Double { get }
    var endX: Double { get }
    
    var startY: Double { get }
    var endY: Double { get }
    
    var points: [PlotPoint] { get }
}

final class Plot: UIView {
    
    var onStartTouches: (() -> Void)?
    var onEndTouches: (() -> Void)?
    
    private let model: PlotModel
    
    private var calculatedStartY: Double?
    private var calculatedEndY: Double?
    
    // MARK: - Views
    
    private let titleLabel = UILabel(text: "% побед",
                                     color: FeatureColor.Dota2Stats.Plot.title,
                                     font: .ryloth)
    private lazy var canvas = PlotCanvas(dataSource: self)
    private lazy var yAxisView = PlotValueAxisView(dataSource: self)
    private lazy var xAxisView = PlotTimestampAxisView(dataSource: self)
    
    // MARK: - Init
    
    init(model: PlotModel) {
        self.model = model
        super.init(frame: .zero)
        prepareDataSource()
        configureUI()
        isMultipleTouchEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func redraw() {
        canvas.setNeedsDisplay()
        xAxisView.setNeedsDisplay()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        addSubview(titleLabel)
        addSubview(canvas)
        addSubview(xAxisView)
        addSubview(yAxisView)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(canvas)
            $0.top.equalToSuperview().offset(2.0)
        }
        
        canvas.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24.0)
            $0.right.equalToSuperview().inset(6.0)
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.width.equalTo(canvas.snp.height).multipliedBy(1.94)
        }
        
        yAxisView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(6.0)
            $0.top.bottom.equalTo(canvas)
            $0.width.equalTo(18.0)
        }
        
        xAxisView.snp.makeConstraints {
            $0.top.equalTo(canvas.snp.bottom)
            $0.left.right.equalTo(canvas)
            $0.height.equalTo(40.0)
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Touches
    
    private var relativeMinX = 0.0
    private var relativeMaxX = 1.0
    
    private var pinchActive = false
    private var previousPotentialDiff: Double?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count < 3 else { return }
        onStartTouches?()
        switch touches.count {
        case 1: pinchActive = false
        case 2: pinchActive = true
        default: break
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count < 3 else { return }
        let touchesArray = Array(touches)
        if touchesArray.count == 1, let touch = touchesArray.first, !pinchActive {
            let location = touch.location(in: self)
            let previousLocation = touch.previousLocation(in: self)
            let shiftX = location.x - previousLocation.x
            
            let coef = -(1 / Double(canvas.bounds.width)) * (relativeMaxX - relativeMinX)
            
            var potentialDiff = coef * Double(shiftX)
            if self.previousPotentialDiff == 0 {
                potentialDiff = potentialDiff / exp(100 * abs(potentialDiff))
            }
            self.previousPotentialDiff = potentialDiff
            
            if potentialDiff > 0 {
                let relMaxX = self.relativeMaxX
                let newRelMaxX = min(1, relMaxX + potentialDiff)
                let diff = newRelMaxX - relMaxX
                self.relativeMinX += diff
                self.relativeMaxX += diff
            } else if potentialDiff < 0 {
                let relMinX = self.relativeMinX
                let newRelMinX = max(0, relMinX + potentialDiff)
                let diff = newRelMinX - relMinX
                self.relativeMinX += diff
                self.relativeMaxX += diff
            }
            redraw()
            
        } else if touchesArray.count == 2, let touch1 = touchesArray.first, let touch2 = touchesArray.last {
            pinchActive = true
            let location1 = touch1.location(in: self)
            let previousLocation1 = touch1.previousLocation(in: self)
            let location2 = touch2.location(in: self)
            let previousLocation2 = touch2.previousLocation(in: self)
            let scaleX = (location2.x - location1.x) / (previousLocation2.x - previousLocation1.x)
            
            let coef = 0.8
            let potentialDiff = coef * Double(scaleX - 1)
            let relativeMinX = self.relativeMinX
            let relativeMaxX = self.relativeMaxX
            var diff = potentialDiff
            if (relativeMaxX - relativeMinX) - 2 * potentialDiff < 0.2 {
                diff = ((relativeMaxX - relativeMinX) - 0.2) / 2.0
            }
            
            let newRelMinX = relativeMinX + diff
            let newRelMaxX = relativeMaxX - diff
            
            self.relativeMinX = max(0, newRelMinX)
            self.relativeMaxX = min(1, newRelMaxX)
            redraw()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count < 3 else { return }
        onEndTouches?()
        if touches.count == 2 {
            pinchActive = false
        }
    }
}

// MARK: - PlotDataSource

extension Plot: PlotDataSource {
    
    var startX: TimeInterval {
        return model.beginTimestamp + relativeMinX * width
    }
    
    var endX: TimeInterval {
        return model.beginTimestamp + relativeMaxX * width
    }
    
    var startY: Double {
        return calculatedStartY ?? 0
    }
    
    var endY: Double {
        return calculatedEndY ?? 1
    }
    
    var points: [PlotPoint] {
        model.points
    }
    
    // MARK: Private
    
    private func prepareDataSource() {
        prepareVerticalValues()
    }
    
    private func prepareVerticalValues() {
        let ascending = model.points.sorted { $0.value < $1.value }
        guard let minValue = ascending.first?.value, let maxValue = ascending.last?.value else {
            return
        }
        /// Добавить снизу и сверху половину от разницы между макс и мин (но не уйти за границы 0...1)
        let additionalSpace = 0.5 * (maxValue - minValue)
        let minY = max(0, minValue - additionalSpace)
        let maxY = min(1, maxValue + additionalSpace)
        
        let minYPercents = minY * 100.0
        let maxYPercents = maxY * 100.0
        
        /// Нижнее значение округлить вверх до ближайшего кратного 5 %
        var roundedMinYPercents = ceil(minYPercents / 5.0) * 5.0
        /// Верхнее значение округлить вниз до ближайшего краного 5 %
        var roundedMaxYPercents = floor(maxYPercents / 5.0) * 5.0
        
        var roundedMinY = roundedMinYPercents / 100.0
        var roundedMaxY = roundedMaxYPercents / 100.0
        
        /// Если после округления некоторые значения оказались за пределами, то проделать округление в другую сторону
        let outValueLessThanMinY = ascending.first { $0.value < roundedMinY }
        let outValueGreaterThanMaxY = ascending.first { $0.value > roundedMaxY }
        if outValueLessThanMinY != nil {
            roundedMinYPercents = floor(minYPercents / 5.0) * 5.0
            roundedMinY = roundedMinYPercents / 100.0
        }
        if outValueGreaterThanMaxY != nil {
            roundedMaxYPercents = ceil(maxYPercents / 5.0) * 5.0
            roundedMaxY = roundedMaxYPercents / 100.0
        }
        
        calculatedStartY = roundedMinY
        calculatedEndY = roundedMaxY
    }
    
    private var width: TimeInterval {
        model.endTimestamp - model.beginTimestamp
    }
}
