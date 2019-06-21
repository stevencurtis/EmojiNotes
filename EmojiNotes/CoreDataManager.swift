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
    func getTasks() -> [NSManagedObject]
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
    
    func getTasks() -> [NSManagedObject] {
        
        if tasks.count > 0 {return tasks}
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Constants.entityName)
        do {
            tasks = try managedObjectContext.fetch(fetchRequest)
            if tasks.count == 0 {
                let entityOne = NSEntityDescription.insertNewObject(forEntityName: Constants.entityName, into: managedObjectContext)
                entityOne.setValue(false, forKey: Constants.entityCompletedattribute)
                entityOne.setValue("Enter your task", forKey: Constants.entityNameAttribute)
                tasks.append(entityOne)
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return tasks
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
    
}