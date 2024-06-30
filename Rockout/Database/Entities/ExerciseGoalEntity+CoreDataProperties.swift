//
//  ExerciseGoalEntity+CoreDataProperties.swift
//  
//
//  Created by Kostya Lee on 17/05/24.
//
//

import Foundation
import CoreData


extension ExerciseGoalEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseGoalEntity> {
        return NSFetchRequest<ExerciseGoalEntity>(entityName: "ExerciseGoalEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var note: String?
    @NSManaged public var reps: String?
    @NSManaged public var restTime: Int16
    @NSManaged public var sets: String?
    @NSManaged public var weight: String?
    @NSManaged public var exerciseConfig: ExerciseConfigEntity?

}
