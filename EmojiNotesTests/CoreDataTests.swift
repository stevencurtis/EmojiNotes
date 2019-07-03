//
//  CoreDataTests.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 02/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
import CoreData
@testable import EmojiNotes


class CoreDataTests: XCTestCase {
    
    var storeCordinator: NSPersistentStoreCoordinator!

    var managedObjectModel: NSManagedObjectModel!
    var store: NSPersistentStore!
    
    override func tearDown() {
        do {
            try storeCordinator.remove(store)
        }
        catch {
            XCTFail("Failed to remove persistent store, \(error)")
        }
    }
    
    override func setUp() {
        super.setUp()
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        storeCordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            store = try storeCordinator.addPersistentStore(
                ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            XCTFail("Failed to create a persistent store, \(error)")
        }
    }

    func testCoreDataSimpleAddNoteItem() {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCordinator
        
        let entity = NSEntityDescription.entity(forEntityName: Constants.entityName, in: managedObjectContext)!
        let coreDataManager = CoreDataManager(mainObjectContext: managedObjectContext, entity: entity)
        let note = Note(entity: entity, insertInto: coreDataManager.getMainManagedObjectContext()!)
        note.contents = "Contents"
        note.title = "title"
        note.createdAt = Date()
        note.contents = "contents"
        note.emoji = String(describing: 0x1F601)
        note.updatedAt = Date()

        coreDataManager.getMainManagedObjectContext()!.performAndWait {
            try! coreDataManager.getChildManagedObjectContext()!.save()
        }

        coreDataManager.getMainManagedObjectContext()!.performAndWait {
            let request = NSFetchRequest<Note>(entityName: Constants.entityName)
            request.returnsObjectsAsFaults = false
            do {
                let result = try managedObjectContext.fetch(request)
                for data in result as [NSManagedObject] {
                    XCTAssertEqual(data.value(forKey: "title") as! String, "title")
                }
            } catch {
                print("Failed")
            }
        }
    }
        
    func testCoreDataAddCategories() {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCordinator
        
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedObjectContext)!
        let coreDataManager = CoreDataManager(mainObjectContext: managedObjectContext, entity: entity)
        
        let categoryPurple = Category(entity: entity, insertInto: coreDataManager.getMainManagedObjectContext()!)
        categoryPurple.color = UIColor.purple as NSObject
        categoryPurple.name = "purple"
        
        try! coreDataManager.getMainManagedObjectContext()!.save()
        
        coreDataManager.getMainManagedObjectContext()!.performAndWait {
            let request = NSFetchRequest<EmojiNotes.Category>(entityName: "Category")
            request.returnsObjectsAsFaults = false
            do {
                let result = try managedObjectContext.fetch(request)
                for data in result as [NSManagedObject] {
                    XCTAssertEqual(data.value(forKey: "name") as! String, "purple")
                }
            } catch {
                print("Failed")
            }
        }

    }
    
    func testCoreDataAddTwoCategories() {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCordinator
        
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedObjectContext)!
        let coreDataManager = CoreDataManager(mainObjectContext: managedObjectContext, entity: entity)
        
        let categoryPurple = Category(entity: entity, insertInto: coreDataManager.getMainManagedObjectContext()!)
        categoryPurple.color = UIColor.purple as NSObject
        categoryPurple.name = "purple"
        
        let categoryBlue = Category(entity: entity, insertInto: coreDataManager.getMainManagedObjectContext()!)
        categoryBlue.color = UIColor.blue as NSObject
        categoryBlue.name = "blue"
        
        try! coreDataManager.getMainManagedObjectContext()!.save()
        
        coreDataManager.getMainManagedObjectContext()!.performAndWait {
            let request = NSFetchRequest<EmojiNotes.Category>(entityName: "Category")
            request.returnsObjectsAsFaults = false
            do {
                let result = try managedObjectContext.fetch(request)
                XCTAssertEqual(result.count, 2)
            } catch {
                print("Failed")
            }
        }
        
        }
    
    func testCoreDataAddFullNote() {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCordinator
        
        let noteEntity = NSEntityDescription.entity(forEntityName: "Note", in: managedObjectContext)!
        let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: managedObjectContext)!
        let pictureEntity = NSEntityDescription.entity(forEntityName: "NotePicture", in: managedObjectContext)!

        let coreDataManager = CoreDataManager(mainObjectContext: managedObjectContext, entity: noteEntity)
        
        let note = Note(entity: noteEntity, insertInto: coreDataManager.getMainManagedObjectContext()!)
        note.contents = "Contents"
        note.title = "title"
        note.createdAt = Date()
        note.contents = "contents"
        note.emoji = String(describing: 0x1F601)
        note.updatedAt = Date()
        
        let noteTwo = EmojiNotes.Note(entity: noteEntity, insertInto: coreDataManager.getMainManagedObjectContext()!)
        noteTwo.contents = "Contents"
        noteTwo.title = "title"
        noteTwo.createdAt = Date()
        noteTwo.contents = "contents"
        noteTwo.emoji = String(describing: 0x1F601)
        noteTwo.updatedAt = Date()
        
        let category = EmojiNotes.Category(entity: categoryEntity, insertInto: coreDataManager.getMainManagedObjectContext()!)
        category.color = UIColor.purple
        category.name = "purple"
        
        let notePicture = NotePicture(entity: pictureEntity, insertInto: coreDataManager.getMainManagedObjectContext()!)
        notePicture.picture = UIImage(named: "test.png", in: Bundle(for: type(of: self)), compatibleWith: nil)?.pngData()
        notePicture.note = note
        note.category = category
        
        coreDataManager.getMainManagedObjectContext()!.performAndWait {
            try! coreDataManager.getChildManagedObjectContext()!.save()
        }
        
        coreDataManager.getMainManagedObjectContext()!.performAndWait {
            let request = NSFetchRequest<Note>(entityName: Constants.entityName)
            request.returnsObjectsAsFaults = false
            do {
                let result = try managedObjectContext.fetch(request)
                let picture  = UIImage(named: "test.png", in: Bundle(for: type(of: self)), compatibleWith: nil)?.pngData()
                XCTAssertEqual( result.first!.picture?.picture, picture  )
            } catch {
                print("Failed")
            }
        }

    }


}
