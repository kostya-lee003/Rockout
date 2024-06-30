//
//  ExerciseDataEntity+CoreDataProperties.swift
//  
//
//  Created by Kostya Lee on 17/05/24.
//
//

import Foundation
import CoreData


extension ExerciseDataEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseDataEntity> {
        return NSFetchRequest<ExerciseDataEntity>(entityName: "ExerciseDataEntity")
    }

    @NSManaged public var desc: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?

}
