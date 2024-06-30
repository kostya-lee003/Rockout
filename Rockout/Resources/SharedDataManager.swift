//
//  SharedDataManager.swift
//  Rockout
//
//  Created by Kostya Lee on 15/05/24.
//

import Foundation

public class SharedDataManager {
    public static func getConvertedRestTime(_ restTime: Int16?) -> String {
        guard let restTime, let rest = Int(exactly: restTime) else { return "0" }
        let minutes = rest / 60
        let seconds = rest - (minutes * 60)
        let secondsStr = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let str = "\(minutes):\(secondsStr)"
        return str
    }
}
