//
//  Histogram.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 06.12.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

final class Histogram: UIViewController {
    
    // MARK: - Properties
    
    struct Config {
        let valueFont: UIFont
        let valueColor: UIColor
        let columnColor: UIColor
        let columnWidth: CGFloat
        let imageRounded: Bool
        let insets: UIEdgeInsets
    }
    
    struct Column {
        let value: CGFloat
        let text: String?
        let imageName: String?
    }
    
    var config: Config{
        didSet { collectionView.reloadData() }
    }
    var columns: [Column] {
        didSet { collectionView.reloadData() }
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = config.insets
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HistogramColumnCell.self, forCellWithReuseIdentifier: HistogramColumnCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Init
    
    init(config: Config, columns: [Column]) {
        self.config = config
        self.columns = columns
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - UI
    
    private func configureUI() {
        view.addSubview(collectionView)
        collectionView.snp.pinToAllSuperviewEdges()
    }
}

// MARK: - UICollectionViewDataSource

extension Histogram: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return columns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HistogramColumnCell.reuseIdentifier, for: indexPath) as! HistogramColumnCell
        guard let column = columns[safe: indexPath.row] else { return cell }
        cell.columnRelativeHeight = column.value
        cell.imageName = column.imageName
        cell.imageRounded = config.imageRounded
        cell.columnView.backgroundColor = config.columnColor
        cell.valueLabel.font = config.valueFont
        cell.valueLabel.textColor = config.valueColor
        cell.valueLabel.text = column.text
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension Histogram: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: config.columnWidth, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4.0
    }
}
