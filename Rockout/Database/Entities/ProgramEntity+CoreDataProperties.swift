//
//  ProgramEntity+CoreDataProperties.swift
//  
//
//  Created by Kostya Lee on 17/05/24.
//
//

import Foundation
import CoreData


extension ProgramEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgramEntity> {
        return NSFetchRequest<ProgramEntity>(entityName: "ProgramEntity")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var desc: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var days: NSOrderedSet?

}

// MARK: Generated accessors for days
extension ProgramEntity {

    @objc(insertObject:inDaysAtIndex:)
    @NSManaged public func insertIntoDays(_ value: DayEntity, at idx: Int)

    @objc(removeObjectFromDaysAtIndex:)
    @NSManaged public func removeFromDays(at idx: Int)

    @objc(insertDays:atIndexes:)
    @NSManaged public func insertIntoDays(_ values: [DayEntity], at indexes: NSIndexSet)

    @objc(removeDaysAtIndexes:)
    @NSManaged public func removeFromDays(at indexes: NSIndexSet)

    @objc(replaceObjectInDaysAtIndex:withObject:)
    @NSManaged public func replaceDays(at idx: Int, with value: DayEntity)

    @objc(replaceDaysAtIndexes:withDays:)
    @NSManaged public func replaceDays(at indexes: NSIndexSet, with values: [DayEntity])

    @objc(addDaysObject:)
    @NSManaged public func addToDays(_ value: DayEntity)

    @objc(removeDaysObject:)
    @NSManaged public func removeFromDays(_ value: DayEntity)

    @objc(addDays:)
    @NSManaged public func addToDays(_ values: NSOrderedSet)

    @objc(removeDays:)
    @NSManaged public func removeFromDays(_ values: NSOrderedSet)

}
