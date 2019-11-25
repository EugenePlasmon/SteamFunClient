//
//  UILabel+Initializers.swift
//  SteamFunClient
//
//  Created by Evgeny Kireev on 25.11.2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

public extension UILabel {
    
    convenience init(text: String? = nil,
                     color: UIColor = .black,
                     font: UIFont = .systemFont(ofSize: 17.0),
                     numberOfLines: Int = 1,
                     textAlignment: NSTextAlignment = .natural,
                     compressionResistancePriorityX: UILayoutPriority? = nil,
                     compressionResistancePriorityY: UILayoutPriority? = nil,
                     contentHuggingPriorityX: UILayoutPriority? = nil,
                     contentHuggingPriorityY: UILayoutPriority? = nil) {
        self.init(frame: .zero)
        self.text = text
        self.textColor = color
        self.font = font
        self.numberOfLines = numberOfLines
        self.textAlignment = textAlignment
        compressionResistancePriorityX >>- { setContentCompressionResistancePriority($0, for: .horizontal) }
        compressionResistancePriorityY >>- { setContentCompressionResistancePriority($0, for: .vertical) }
        contentHuggingPriorityX >>- { setContentHuggingPriority($0, for: .horizontal) }
        contentHuggingPriorityY >>- { setContentHuggingPriority($0, for: .vertical) }
    }
}
