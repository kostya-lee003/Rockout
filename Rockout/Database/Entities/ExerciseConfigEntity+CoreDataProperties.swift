//
//  ExerciseConfigEntity+CoreDataProperties.swift
//  
//
//  Created by Kostya Lee on 17/05/24.
//
//

import Foundation
import CoreData


extension ExerciseConfigEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseConfigEntity> {
        return NSFetchRequest<ExerciseConfigEntity>(entityName: "ExerciseConfigEntity")
    }

    @NSManaged public var exerciseInfoId: String?
    @NSManaged public var exerciseName: String?
    @NSManaged public var id: UUID?
    @NSManaged public var rests: NSObject?
    @NSManaged public var day: DayEntity?
    @NSManaged public var exerciseGoal: ExerciseGoalEntity?
    @NSManaged public var sets: NSOrderedSet?

}

// MARK: Generated accessors for sets
extension ExerciseConfigEntity {

    @objc(insertObject:inSetsAtIndex:)
    @NSManaged public func insertIntoSets(_ value: SetEntity, at idx: Int)

    @objc(removeObjectFromSetsAtIndex:)
    @NSManaged public func removeFromSets(at idx: Int)

    @objc(insertSets:atIndexes:)
    @NSManaged public func insertIntoSets(_ values: [SetEntity], at indexes: NSIndexSet)

    @objc(removeSetsAtIndexes:)
    @NSManaged public func removeFromSets(at indexes: NSIndexSet)

    @objc(replaceObjectInSetsAtIndex:withObject:)
    @NSManaged public func replaceSets(at idx: Int, with value: SetEntity)

    @objc(replaceSetsAtIndexes:withSets:)
    @NSManaged public func replaceSets(at indexes: NSIndexSet, with values: [SetEntity])

    @objc(addSetsObject:)
    @NSManaged public func addToSets(_ value: SetEntity)

    @objc(removeSetsObject:)
    @NSManaged public func removeFromSets(_ value: SetEntity)

    @objc(addSets:)
    @NSManaged public func addToSets(_ values: NSOrderedSet)

    @objc(removeSets:)
    @NSManaged public func removeFromSets(_ values: NSOrderedSet)

}
