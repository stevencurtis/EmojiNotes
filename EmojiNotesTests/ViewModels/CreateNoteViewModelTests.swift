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
    // the following strategy relied on us CHANGING production code to be able to test
    // then used the extension to override the init for NSManagedContext
    func testAddNote() {
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = storeCordinator
        
        let noteEntity = NSEntityDescription.entity(forEntityName: "Note", in: managedObjectContext)!
//        let pictureEntity = NSEntityDescription.entity(forEntityName: "NotePicture", in: managedObjectContext)!
//        let categoryEntity = NSEntityDescription.entity(forEntityName: "Category", in: managedObjectContext)!

        
        let coreDataManager = CoreDataManager(mainObjectContext: managedObjectContext, entity: noteEntity)
        let createNoteModel = CreateNoteViewModel(coreDataManager)
        
        let img = UIImage(named: "test.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
        // createNoteModel.addNote(with: "Title", contents: "Contents", emoji: String(describing: 0x1F601) , img: img, noteEntity: noteEntity, pictureEntity: pictureEntity, categoryEntity: categoryEntity)
        createNoteModel.addNote(with: "Title", contents: "Contents", emoji: String(describing: 0x1F601) , img: img)
        
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
    
    
    func testAddNoteUsingMock() {
        let cdm = CoreDataManagerMock()
        
        let createNoteModel = CreateNoteViewModel(cdm)
        
        let img = UIImage(named: "test.png", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
        createNoteModel.addNote(with: "TitleAddNote", contents: "Contents", emoji: String(describing: 0x1F601) , img: img)
        
        cdm.getMainManagedObjectContext()!.performAndWait {
            let request = NSFetchRequest<Note>(entityName: "Note")
            request.returnsObjectsAsFaults = false
            do {
                let result = try cdm.getMainManagedObjectContext()!.fetch(request)
                XCTAssertEqual(result.count, 2)
//                for data in result as [NSManagedObject] {
//                    XCTAssertEqual(data.value(forKey: "title") as! String, "MockNoteTitle")
//                }
            } catch {
                print("Failed")
            }
        }

    }
    
    func testCDMock() {
        let cdm = CoreDataManagerMock()
        
        cdm.getMainManagedObjectContext()!.performAndWait {
            let request = NSFetchRequest<Note>(entityName: "Note")
            request.returnsObjectsAsFaults = false
            do {
                let result = try cdm.getMainManagedObjectContext()!.fetch(request)
                for data in result as [NSManagedObject] {
                    XCTAssertEqual(data.value(forKey: "title") as! String, "MockNoteTitle")
                }
            } catch {
                print("Failed")
            }
        }
    }

    
    // get categories is async, so use of XCTestExpectation here
    func testGetCategories() {
        let expectation = XCTestExpectation(description: #function)

        let cdm = CoreDataManagerMock()
        let createNoteModel = CreateNoteViewModel(cdm)
        createNoteModel.getCategories{ cats in
            let cas = cats
            XCTAssertEqual(cas.first!.name, "blue")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)

    }

}
