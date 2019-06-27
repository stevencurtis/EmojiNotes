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
    func save(task: String)
    init()
}

class CoreDataManager: CoreDataManagerProtocol {
    
    private var tasks = [NSManagedObject]()

    private var managedObjectContext: NSManagedObjectContext! = nil
    private var entity: NSEntityDescription! = nil
    
    func getManagedObjectContext() -> NSManagedObjectContext? {
        return managedObjectContext
    }
    
    init (objectContext: NSManagedObjectContext, entity: NSEntityDescription) {
        self.managedObjectContext = objectContext
        self.entity = entity
    }
    
    required init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        // This context is associated directly with the NSPersistentStoreCoordinator and is non-generational by default.
        // This is the managed object context generated as part of the new core data App checkbox!
        managedObjectContext = appDelegate.persistentContainer.viewContext

        entity = NSEntityDescription.entity(forEntityName: Constants.entityName, in: managedObjectContext)!
    }
    
    func save(task: String) {
        let taskObject = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        taskObject.setValue(task, forKeyPath: Constants.entityNameAttribute)
        do {
            try managedObjectContext.save()
            tasks.append(taskObject)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func saveContext () {
        guard managedObjectContext.hasChanges else { return }


        do {
            try managedObjectContext.save()
            
            // inform listeners that we have updated the model
            // NotificationCenter.default.post(name: Notification.Name.dataModelDidUpdateNotification, object: self, userInfo: nil)
            
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

    
}
