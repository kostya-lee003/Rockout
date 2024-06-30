//
//  Frames.swift
//  Rockout
//
//  Created by Kostya Lee on 25/10/23.
//

import Foundation
import UIKit

extension CGFloat {
    static let cellImageSize = UIScreen.main.bounds.width / 4.7
    static let separatorHeight = 1.5
    static let topSafePadding = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
    static let bottomSafePadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
}

// padding used everywhere
let padding = UIScreen.main.bounds.width / 20
