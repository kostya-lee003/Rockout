//
//  SetEntity+CoreDataProperties.swift
//  
//
//  Created by Kostya Lee on 17/05/24.
//
//

import Foundation
import CoreData


extension SetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SetEntity> {
        return NSFetchRequest<SetEntity>(entityName: "SetEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var reps: Int32
    @NSManaged public var weight: Float
    @NSManaged public var exerciseConfig: ExerciseConfigEntity?

}
