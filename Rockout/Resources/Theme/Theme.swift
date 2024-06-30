//
//  Theme.swift
//  Rockout
//
//  Created by Kostya Lee on 09/05/23.
//

import UIKit

public enum Theme: Int {
    case device
    case light
    case dark
    
    public func getUserInterfaceStyle() -> UIUserInterfaceStyle {
        switch self {
        case .device:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
