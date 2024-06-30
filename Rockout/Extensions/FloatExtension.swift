//
//  FloatExtension.swift
//  Rockout
//
//  Created by Kostya Lee on 29/05/24.
//

import Foundation

extension Float {
    func hasFractionalPart() -> Bool {
        return self.truncatingRemainder(dividingBy: 1) != 0
    }
}
