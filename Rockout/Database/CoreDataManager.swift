//
//  CoreDataManager.swift
//  Rockout
//
//  Created by Kostya Lee on 26/12/23.
//

import Foundation
import CoreData
import UIKit

public class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Rockout")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
}

// MARK: Functions
extension CoreDataManager {
    public func fetchExerciseDataEntity(with id: String) -> ExerciseDataEntity? {
        // Define the fetch request
        let fetchRequest: NSFetchRequest<ExerciseDataEntity> = ExerciseDataEntity.fetchRequest()

        // Set up a predicate to filter results by ID
        let idPredicate = NSPredicate(format: "id == %@", id)

        // Assign the predicate to the fetch request
        fetchRequest.predicate = idPredicate

        do {
            // Execute the fetch request
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            
            // Handle the results
            if let entity = results.first {
                // Entity with the specific ID found
                return entity
            } else {
                // Entity with the specific ID not found
                return nil
            }
        } catch {
            logFetchEntityError(
                methodName: #function,
                className: String(describing: self)
            )
            return nil
        }
    }

    public func saveContext() {
        do {
            try context.save()
        } catch {
            self.logSaveEntityError(methodName: #function, className: String(describing: self))
        }
    }
}

// MARK: Logging
extension CoreDataManager {
    public func log(_ error: String) {
        
    }

    public func logFetchEntityError(methodName: String, className: String) {
        NSLog(commonLogFormat, "Fetch Entity error: \(className) - \(methodName)")
    }

    public func logSaveEntityError(methodName: String, className: String) {
        NSLog(commonLogFormat, "Save Entity error: \(className) - \(methodName)")
    }
}

// MARK: Helper functions
extension CoreDataManager {
    // Fetch DayEntity with id
    public func getDayWithId(id: String) -> DayEntity? {
        // Define the fetch request
        let fetchRequest: NSFetchRequest<DayEntity> = DayEntity.fetchRequest()

        guard let uuid = UUID(uuidString: id) else { return nil }
        // Set up a predicate to filter results by ID
        let idPredicate = NSPredicate(format: "id == %@", uuid as CVarArg)

        // Assign the predicate to the fetch request
        fetchRequest.predicate = idPredicate

        do {
            // Execute the fetch request
            let results = try CoreDataManager.shared.context.fetch(fetchRequest)
            
            // Handle the results
            if let entity = results.first {
                // Entity with the specific ID found
                return entity
            } else {
                return nil
            }
        } catch {
            logFetchEntityError(
                methodName: #function,
                className: String(describing: self)
            )
            return nil
        }
    }
}
