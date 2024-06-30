//
//  DayEntity+CoreDataProperties.swift
//  
//
//  Created by Kostya Lee on 17/05/24.
//
//

import Foundation
import CoreData


extension DayEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DayEntity> {
        return NSFetchRequest<DayEntity>(entityName: "DayEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var workoutStartedDate: Date?
    @NSManaged public var workoutEndedDate: Date?
    @NSManaged public var exerciseConfigs: NSOrderedSet?
    @NSManaged public var program: ProgramEntity?

}

// MARK: Generated accessors for exerciseConfigs
extension DayEntity {

    @objc(insertObject:inExerciseConfigsAtIndex:)
    @NSManaged public func insertIntoExerciseConfigs(_ value: ExerciseConfigEntity, at idx: Int)

    @objc(removeObjectFromExerciseConfigsAtIndex:)
    @NSManaged public func removeFromExerciseConfigs(at idx: Int)

    @objc(insertExerciseConfigs:atIndexes:)
    @NSManaged public func insertIntoExerciseConfigs(_ values: [ExerciseConfigEntity], at indexes: NSIndexSet)

    @objc(removeExerciseConfigsAtIndexes:)
    @NSManaged public func removeFromExerciseConfigs(at indexes: NSIndexSet)

    @objc(replaceObjectInExerciseConfigsAtIndex:withObject:)
    @NSManaged public func replaceExerciseConfigs(at idx: Int, with value: ExerciseConfigEntity)

    @objc(replaceExerciseConfigsAtIndexes:withExerciseConfigs:)
    @NSManaged public func replaceExerciseConfigs(at indexes: NSIndexSet, with values: [ExerciseConfigEntity])

    @objc(addExerciseConfigsObject:)
    @NSManaged public func addToExerciseConfigs(_ value: ExerciseConfigEntity)

    @objc(removeExerciseConfigsObject:)
    @NSManaged public func removeFromExerciseConfigs(_ value: ExerciseConfigEntity)

    @objc(addExerciseConfigs:)
    @NSManaged public func addToExerciseConfigs(_ values: NSOrderedSet)

    @objc(removeExerciseConfigs:)
    @NSManaged public func removeFromExerciseConfigs(_ values: NSOrderedSet)

}
