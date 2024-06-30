//
//  ThemeManager+Images.swift
//  Rockout
//
//  Created by Kostya Lee on 12/05/23.
//

import UIKit

extension ThemeManager {
    static var newProgramIcon: UIImage {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIImage(named: "newProgramIcon")!
        default:
            return UIImage(named: "newProgramIcon")!
        }
    }
    
    static var cardsIcon: UIImage {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIImage(named: "exercisesCards")!
        default:
            return UIImage(named: "exercisesCards")!
        }
    }
    
    static var editIcon: UIImage {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIImage(named: "edit")!
        default:
            return UIImage(named: "edit")!
        }
    }
    
    static var whiteEditIcon: UIImage {
        switch UserDefaults.standard.theme.getUserInterfaceStyle() {
        case .dark:
            return UIImage(named: "edit2")!
        default:
            return UIImage(named: "edit2")!
        }
    }
}
