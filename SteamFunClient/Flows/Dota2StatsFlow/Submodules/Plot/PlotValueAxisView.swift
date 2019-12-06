//
//  PlotValueAxisView.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 07.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class PlotValueAxisView: UIView {
    
    private weak var dataSource: PlotDataSource?
    
    typealias Value = (relative: Double, numberToShow: Int)
    private var values: [Value]?
    private var labels: [UILabel] = []
    
    // MARK: - Init
    
    init(dataSource: PlotDataSource) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        backgroundColor = .clear
        prepareValues()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareValues() {
        guard let dataSource = self.dataSource else { return }
        let minY = Int(round(dataSource.startY * 100.0))
        let maxY = Int(round(dataSource.endY * 100.0))
        
        /// Находим все значения между min и max, кратные 5%
        let count = (maxY - minY) / 5
        var numbers = (0...count).map { minY + $0 * 5 }
        
        /// Если значений много (>5, что на графике плохо поместится), то проредим значения, удалив некоторые элементы.
        while numbers.count > 5 {
            numbers = numbers.enumerated().compactMap { $0.offset % 2 == 0 ? $0.element : nil }
        }
        
        let values = numbers.map { number -> Value in
            let relative = (Double(number) / 100.0 - dataSource.startY) / (dataSource.endY - dataSource.startY)
            return (relative, number)
        }
        
        self.values = values
    }
    
    private func configureUI() {
        guard let values = self.values else { return }
        
        self.labels = values.map { value in
            let text = "\(value.numberToShow)"
            let label = UILabel(text: text,
                                color: FeatureColor.Dota2Stats.Plot.value,
                                font: .zurvan)
            label.adjustsFontSizeToFitWidth = true
            label.minimumScaleFactor = 0.5
            addSubview(label)
            label.snp.makeConstraints {
                $0.left.right.equalToSuperview()
                /// Для привязки лейбла по вертикали пользуемся констрейнтом centerY.
                /// Его multiplier работает так, что 2 означает привязка к низу, 1 - к центру, близкое к 0 - к верху.
                var multiplier = 2.0 * (1.0 - value.relative)
                if multiplier == 0 { multiplier = 0.00000000001 }
                $0.centerY.equalToSuperview().multipliedBy(multiplier)
            }
            return label
        }
    }
}
