//
//  DateComponentsExtension.swift
//  Rockout
//
//  Created by Kostya Lee on 27/05/24.
//

import Foundation

extension DateComponents {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(year)
        hasher.combine(month)
        hasher.combine(day)
    }

    public static func == (lhs: DateComponents, rhs: DateComponents) -> Bool {
        return lhs.year == rhs.year &&
               lhs.month == rhs.month &&
               lhs.day == rhs.day
    }
}

func removeDuplicates(from array: [DateComponents]) -> [DateComponents] {
    var seen = Set<DateComponents>()
    let uniqueComponents = array.filter { seen.insert($0).inserted }
    return uniqueComponents
}
