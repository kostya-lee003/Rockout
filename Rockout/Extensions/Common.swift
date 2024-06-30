//
//  Common.swift
//  Rockout
//
//  Created by Kostya Lee on 03/03/24.
//

import Foundation

public typealias CompletionHandler = (() -> Void)?

/// For table view in ExerciseConfigurationController
public let dateFormatForSections = "d MMMM (E), yyyy"
public let dateFormatForCell = "HH:mm"

public enum PreferredWeightIndicator: Int {
    case kg = 0
    case lbs = 1
}

public let rest_notification_id = "NOTIFICATION_ID"
