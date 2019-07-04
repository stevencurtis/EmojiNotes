//
//  CoreDataManagerMock.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 03/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import CoreData
import UIKit
@testable import EmojiNotes

protocol CoreDataMockProtocol {
    func getTaskObjectIds() -> [NSManagedObjectID]
    func getCategoryIds() -> [NSManagedObjectID]

    func getCategories() -> [NSManagedObject]
}

typealias CDMMock = CoreDataManagerProtocol & CoreDataMockProtocol

class CoreDataManagerMock: CDMMock {
    
    // MARK: Properties
//    private let modelName: String
    
    private var managedObjectContext: NSManagedObjectContext! = nil

    var storeCordinator: NSPersistentStoreCoordinator!
    var store: NSPersistentStore!
    
    var managedObjectModel: NSManagedObjectModel!
    
    var taskObjectIds = [NSManagedObjectID]()
    
    var categoriesStore = [NSManagedObject]()
    
    var categoriesIds = [NSManagedObjectID]()
    
    func getCategoryIds() -> [NSManagedObjectID] {
        return categoriesIds
    }
    
    func getCategories() -> [NSManagedObject] {
            return categoriesStore
    }
    
    func getTaskObjectIds() -> [NSManagedObjectID] {
        return taskObjectIds
    }
    
    required init() {
//        let url = Bundle.main.url(forResource: "named", withExtension: "momd")!
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
//        let managedObjectModel = NSManagedObjectModel.init(contentsOf: url)

        storeCordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCordinator
        
        // put in a note into the mock
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedObjectContext)
        let taskObject = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        taskObject.setValue("MockNoteTitle", forKey: "title")
        taskObjectIds.append(taskObject.objectID)
        
        let entityCat = NSEntityDescription.entity(forEntityName: "Category", in: managedObjectContext)
        let categoryObject = NSManagedObject(entity: entityCat!, insertInto: managedObjectContext)
        categoryObject.setValue(UIColor.blue, forKey: "color")
        categoryObject.setValue("blue", forKey: "name")
        
        categoriesStore.append(categoryObject)
        categoriesIds.append(categoryObject.objectID)
    }
    
    func saveContext() {
        //
    }
    
    func getMainManagedObjectContext() -> NSManagedObjectContext? {
        //
        return managedObjectContext
    }
    
    func getChildManagedObjectContext() -> NSManagedObjectContext? {
        //
        return nil
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
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


