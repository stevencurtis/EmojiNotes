//
//  CoreDataManager.swift
//  CoreDataToDoTesting
//
//  Created by Steven Curtis on 14/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//Users/stevencurtis/Documents/Interviewprep/MediumPosts/CoreDataBasicsWithTests/CoreDataToDoTesting/CoreDataToDoTesting/Others/Constants.swift/

import UIKit
import CoreData

public protocol CoreDataManagerProtocol {
    func saveContext ()
    init()
    func getMainManagedObjectContext() -> NSManagedObjectContext?
    func getChildManagedObjectContext() -> NSManagedObjectContext?
    func saveContext (_ context: NSManagedObjectContext)
}

class CoreDataManager: CoreDataManagerProtocol {
    
    // MARK: Properties
    private let modelName: String
//    private var entity: NSEntityDescription! = nil
    
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        // The alternative to this is to set up our own store
//        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    }()
    
    private var managedObjectContext: NSManagedObjectContext! = nil
    
    private(set) lazy var childManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let myChildManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        myChildManagedObjectContext.parent = self.managedObjectContext
        
        return myChildManagedObjectContext
    }()
    
    // NSPersistentContainer - hides implementation details of how persistent stores are configured
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    
    func getMainManagedObjectContext() -> NSManagedObjectContext? {
        return managedObjectContext
    }
    
    func getChildManagedObjectContext() -> NSManagedObjectContext? {
        return childManagedObjectContext
    }

    init (mainObjectContext: NSManagedObjectContext, entity: NSEntityDescription) {
        self.modelName = Constants.modelName // "EmojiNotes"
        managedObjectContext = mainObjectContext
//        self.entity = NSEntityDescription.entity(forEntityName: Constants.entityName, in: managedObjectContext)!
//        self.entity = entity
    }
    
    required init() {
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        self.modelName = Constants.modelName
    }

    func saveContext (_ context: NSManagedObjectContext) {
        // performblock and execute on correct thread
        context.perform {
            if context.hasChanges {
                do {
                    
                    try context.save()
                    // inform listeners that we have updated the model
                    // NotificationCenter.default.post(name: Notification.Name.dataModelDidUpdateNotification, object: self, userInfo: nil)
                    
                } catch let error as NSError {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
    }
    
    func saveContext () {
        
        if childManagedObjectContext.hasChanges {
            childManagedObjectContext.performAndWait {
                do {
                    
                    try childManagedObjectContext.save()
                    // inform listeners that we have updated the model
                    // NotificationCenter.default.post(name: Notification.Name.dataModelDidUpdateNotification, object: self, userInfo: nil)
                    
                } catch let error as NSError {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
            }
        }
        if managedObjectContext.hasChanges {
            managedObjectContext.perform {
            do {
                
                try self.managedObjectContext.save()
                // inform listeners that we have updated the model
                // NotificationCenter.default.post(name: Notification.Name.dataModelDidUpdateNotification, object: self, userInfo: nil)
                
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
            }
        }

    }

    
}
