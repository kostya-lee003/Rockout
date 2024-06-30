//
//  ThemeManager.swift
//  Rockout
//
//  Created by Kostya Lee on 09/05/23.
//

import UIKit

public struct ThemeManager {
    static var background: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIColor(hex: "#020202")
        default:
            return UIColor(hex: "#F3F3F3")
        }
    }
    
    static var secondaryBackground: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIColor(hex: "#F2F2F7")
        default:
            return UIColor(hex: "#F2F2F7")
        }
    }

    static var description: UIColor {
        return UIColor(hex: "#8A8A8E")
    }

    static var primaryLabel: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIColor(hex: "#E7E7E7")
        default:
            return UIColor(hex: "#1D1D1D")
        }
    }

    static var subtitleColor: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIColor(hex: "#9B9D9F")
        default:
            return UIColor(hex: "#343434")
        }
    }
    
    static var softPrimary: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return .systemGray
        default:
            return UIColor(hex: "#323232")
        }
    }
    
    static var softSecondary: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return .systemGray2
        default:
            return UIColor(hex: "#75808C")
        }
    }

    static var bottomSeparatorColor: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIColor(hex: "#E5E5E5")
        default:
            return UIColor(hex: "#E5E5E5")
        }
    }

    static var cellSeparatorColor: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIColor(hex: "#BCBCBC")
        default:
            return UIColor(hex: "#BCBCBC")
        }
    }
    
    static var cellSeparatorColor2: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return .gray.withAlphaComponent(0.5)
        default:
            return .gray.withAlphaComponent(0.5)
        }
    }

    static var textFieldBorder: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIColor(hex: "#8E8E8E")
        default:
            return UIColor(hex: "#8E8E8E")
        }
    }
    
    static var primaryTint: UIColor {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIColor(hex: "#007AFF")
        default:
            return UIColor(hex: "#007AFF")
        }
    }
}
