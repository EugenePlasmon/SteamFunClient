//
//  PlotTimestampAxisView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit
import CoreText

final class PlotTimestampAxisView: UIView {
    
    private weak var dataSource: PlotDataSource?
    
    private let config: Config
    
    struct Config {
        let dayFont: UIFont = .zurvan
        let dayColor: UIColor = FeatureColor.Dota2Stats.Plot.day
    }
    
    // MARK: - Init
    
    init(dataSource: PlotDataSource?, config: Config = Config()) {
        self.dataSource = dataSource
        self.config = config
        super.init(frame: .zero)
        backgroundColor = .clear
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
        context.clear(rect)
        /// Перевернуть систему координат
        context.saveGState()
        context.textMatrix = .identity
        context.translateBy(x: 0, y: rect.height)
        context.scaleBy(x: 1, y: -1)
        defer { context.restoreGState() }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        guard let dataSource = self.dataSource else { return }
        let startDate = Date(timeIntervalSince1970: dataSource.startX)
//        let endDate = Date(timeIntervalSince1970: dataSource.endX)
        let startString = dateFormatter.string(from: startDate)
//        let endString = dateFormatter.string(from: endDate)
        let attributes: [NSAttributedString.Key: Any] = [.font: config.dayFont, .foregroundColor: config.dayColor]
        let startAttrString = NSAttributedString(string: startString, attributes: attributes)
//        let endAttrString = NSAttributedString(string: endString, attributes: attributes)
        let startStringSize = startAttrString.size()
//        let endStringSize = endAttrString.size()
        
//        let startStringFrame = CGRect(x: rect.minX, y: rect.minY - 15, width: startStringSize.width, height: startStringSize.height)
        let startStringFrame = CGRect(x: 0,
                                      y: rect.height - ceil(startStringSize.height),
                                      width: startStringSize.width,
                                      height: ceil(startStringSize.height))

//        let endStringFrame = CGRect(x: rect.maxX - endStringSize.width, y: rect.minY + 15, width: endStringSize.width, height: endStringSize.height)
        
        let startFramesetter = CTFramesetterCreateWithAttributedString(startAttrString as CFAttributedString)
//        let endFramesetter = CTFramesetterCreateWithAttributedString(endAttrString as CFAttributedString)
        
        let startPath = CGMutablePath()
        startPath.addRect(startStringFrame)
        context.addPath(startPath)
        context.setFillColor(UIColor.red.cgColor)
        context.fillPath()
        let ctStartFrame = CTFramesetterCreateFrame(startFramesetter, CFRange(location: 0, length: 0), startPath, nil)
        
//        let endPath = CGMutablePath()
//        endPath.addRect(endStringFrame)
//        let ctEndFrame = CTFramesetterCreateFrame(endFramesetter, CFRange(location: 0, length: 0), endPath, nil)
        
        CTFrameDraw(ctStartFrame, context)
//        CTFrameDraw(ctEndFrame, context)
    }
}
