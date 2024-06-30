//
//  DateExtension.swift
//  Rockout
//
//  Created by Kostya Lee on 18/03/24.
//

import Foundation

extension Date {
    public static func isToday(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let otherDate = calendar.startOfDay(for: date)
        return today == otherDate
    }
}
