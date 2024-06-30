//
//  Theme+UserDefaults.swift
//  Rockout
//
//  Created by Kostya Lee on 09/05/23.
//

import UIKit

extension UserDefaults {
    var theme: Theme {
        get {
            Theme(rawValue: UserDefaults.standard.integer(forKey: "selectedTheme")) ?? .device
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "selectedTheme")
        }
    }
}
