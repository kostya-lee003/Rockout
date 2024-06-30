//
//  AppDelegate.swift
//  Rockout
//
//  Created by Kostya Lee on 04/12/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        checkIfFirstLaunch()
        setupDictionaries()
        UserDefaultsManager.setPreferredWeightIndicator(.kg)
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Rockout")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    public func checkIfFirstLaunch() {
        
        /// If first lauch then create all exercises and save them into core data
        if UserDefaultsManager.isFirstLaunch() {
            /// Create ExerciseDataObjects and save them to Core Data
            if let ids = readTextFile(fileName: "ids")?.components(separatedBy: "\n"),
               let names = readTextFile(fileName: "names_ru")?.components(separatedBy: "\n"),
               let descriptions = readTextFile(fileName: "descriptions_ru")?.components(separatedBy: "\n\n") {
                for index in 0...ids.count - 1 {
                    let new = ExerciseDataEntity(context: CoreDataManager.shared.context)
                    new.id = ids[index]
                    new.name = names[safe: index]
                    new.desc = descriptions[safe: index]
                    CoreDataManager.shared.saveContext()
                }
            } else {
                NSLog(commonLogFormat, "Something went wrong: AppDelegate - \(#function)")
            }
            
            /// Set workout started bool
            UserDefaultsManager.setWorkoutStarted(false)
            
            // Request for notifications
            requestPremission()
        }
    }

    private func requestPremission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // This method will be called when app received push notifications in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        if notification.request.identifier == rest_notification_id {
            completionHandler([.badge, .sound])
        }
    }
}
