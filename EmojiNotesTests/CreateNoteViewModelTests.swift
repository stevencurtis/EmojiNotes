//
//  CreateNoteViewModelTests.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 03/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
import CoreData
@testable import EmojiNotes

class CreateNoteViewModelTests: XCTestCase {

    override func setUp() {
        managedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
        storeCordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            store = try storeCordinator.addPersistentStore(
                ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            XCTFail("Failed to create a persistent store, \(error)")
        }
    }
    
    override func tearDown() {
        do {
            try storeCordinator.remove(store)
        }
        catch {
            XCTFail("Failed to remove persistent store, \(error)")
        }
    }
    
    
    var storeCordinator: NSPersistentStoreCoordinator!
    var managedObjectModel: NSManagedObjectModel!
    var store: NSPersistentStore!
    
    // Warning: This pretty much just tests adding to core data
    func testAddNote() {
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCordinator
        
        let noteEntity = NSEntityDescription.entity(forEntityName: "Note", in: managedObjectContext)!
        let pictureEntity = NSEntityDescription.entity(forEntityName: "NotePicture", in: managedObjectContext)!

        
        let coreDataManager = CoreDataManager(mainObjectContext: managedObjectContext, entity: noteEntity)
        let createNoteModel = CreateNoteViewModel(coreDataManager)
        
        let img = UIImage(named: "test.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
        createNoteModel.addNote(with: "Title", contents: "Contents", emoji: String(describing: 0x1F601) , img: img, noteEntity: noteEntity, pictureEntity: pictureEntity)
        
        
        coreDataManager.getMainManagedObjectContext()!.performAndWait {
            let request = NSFetchRequest<Note>(entityName: "Note")
            request.returnsObjectsAsFaults = false
            do {
                let result = try managedObjectContext.fetch(request)
                for data in result as [NSManagedObject] {
                    XCTAssertEqual(data.value(forKey: "title") as! String, "Title")
                }
            } catch {
                print("Failed")
            }
        }

    }


}
