//
//  UserDefaultsManager.swift
//  Rockout
//
//  Created by Kostya Lee on 09/02/24.
//

import Foundation

public enum UserDefaultsKey: String {
    case firstLaunch
    case workoutStarted
    case lastSetId
    case preferredWeightIndicator
//    case lastWorkoutDuration
    case lastWorkoutId
}

public struct UserDefaultsManager {
    public static func setFirstLaunch(_ firstLaunch: Bool) {
        UserDefaults.standard.set(firstLaunch, forKey: UserDefaultsKey.firstLaunch.rawValue)
    }

    public static func isFirstLaunch() -> Bool {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: UserDefaultsKey.firstLaunch.rawValue)
        if !isFirstLaunch {
            UserDefaultsManager.setFirstLaunch(true)
        }
        return !isFirstLaunch
    }
    
    public static func setWorkoutStarted(_ workoutStarted: Bool) {
        UserDefaults.standard.set(workoutStarted, forKey: UserDefaultsKey.workoutStarted.rawValue)
    }
    
    public static func isWorkoutStarted() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsKey.workoutStarted.rawValue)
    }

    public static func setLastSetId(_ lastSetId: UUID) {
        UserDefaults.standard.set(lastSetId, forKey: UserDefaultsKey.lastSetId.rawValue)
    }

    public static func getLastSetId() -> UUID {
        UserDefaults.standard.object(forKey: UserDefaultsKey.lastSetId.rawValue) as! UUID
    }
    
    public static func setPreferredWeightIndicator(_ value: PreferredWeightIndicator) {
        UserDefaults.standard.set(value.rawValue, forKey: UserDefaultsKey.preferredWeightIndicator.rawValue)
    }
    
    public static func getPreferredWeightIndicator() -> PreferredWeightIndicator.RawValue {
        UserDefaults.standard.object(forKey: UserDefaultsKey.preferredWeightIndicator.rawValue) as! PreferredWeightIndicator.RawValue
    }

//    public static func setLastWorkoutDuration(_ duration: Int) {
//        UserDefaults.standard.set(duration, forKey: UserDefaultsKey.lastWorkoutDuration.rawValue)
//    }
//    
//    public static func getLastWorkoutDuration() -> Int {
//        UserDefaults.standard.object(forKey: UserDefaultsKey.lastWorkoutDuration.rawValue) as! Int
//    }
    
    public static func setLastWorkoutId(_ id: String?) { // id of DayEntity
        UserDefaults.standard.set(id, forKey: UserDefaultsKey.lastWorkoutId.rawValue)
    }
    
    public static func getLastWorkoutId() -> String? { // id of DayEntity
        UserDefaults.standard.object(forKey: UserDefaultsKey.lastWorkoutId.rawValue) as! String?
    }
}
