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
//    func getTasks() -> [NSManagedObject]
//    func save(task: String)
//    init()
}

class CoreDataManager: CoreDataManagerProtocol {
    
    // MARK: Properties
     private let modelName: String
    
//    private var managedObjectContext: NSManagedObjectContext! = nil
//    lazy var managedObjectContext: NSManagedObjectContext = {
//        return self.storeContainer.viewContext
//    }()-

    lazy var managedObjectContext: NSManagedObjectContext = {
        // The alternative to this is to set up our own store
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }()
    
//    private lazy var childManagedObjectContext: NSManagedObjectContext = {
//        return NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//    }()
    
    
    private(set) lazy var childManagedObjectContext: NSManagedObjectContext = {
        // Initialize Managed Object Context
        let myChildManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        
        // Configure Managed Object Context
        myChildManagedObjectContext.parent = self.managedObjectContext
        
        return myChildManagedObjectContext
    }()
    
//    var childManagedObjectContext: NSManagedObjectContext?
//
//    func setChildManagedObjectContext(_ tmpContext: NSManagedObjectContext, _ parent: NSManagedObjectContext) {
//        let childContext = tmpContext
//        childContext.parent = parent
//        childManagedObjectContext = childContext
//    }
    
    // NSPersistentContainer - hides implementation details of how persistent stores are configured
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "EmojiNotes")        
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
//        self.managedObjectContext = mainObjectContext
//        self.entity = entity
        self.modelName = "EmojiNotes"
    }
    
    required init() {
        self.modelName = "EmojiNotes" //Constants.entityName

        guard let _ = UIApplication.shared.delegate as? AppDelegate else { return }
        // This context is associated directly with the NSPersistentStoreCoordinator and is non-generational by default.
        // This is the managed object context generated as part of the new core data App checkbox!
        
        // if not lazy
//        managedObjectContext = appDelegate.persistentContainer.viewContext // the managed object context associated with the main queue
//        managedObjectContext = self.storeContainer.viewContext // my own manged object context

        
//        entity = NSEntityDescription.entity(forEntityName: Constants.entityName, in: managedObjectContext)!
    }

    func saveContext (_ context: NSManagedObjectContext) {
        // performblock and execute on correct threa
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
//            childManagedObjectContext.performAndWait {
                do {
                    
                    try childManagedObjectContext.save()
                    // inform listeners that we have updated the model
                    // NotificationCenter.default.post(name: Notification.Name.dataModelDidUpdateNotification, object: self, userInfo: nil)
                    
                } catch let error as NSError {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
//            }
        }
        
        if managedObjectContext.hasChanges {
            do {
                
                try managedObjectContext.save()
                // inform listeners that we have updated the model
                // NotificationCenter.default.post(name: Notification.Name.dataModelDidUpdateNotification, object: self, userInfo: nil)
                
            } catch let error as NSError {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }

    }

    
}
