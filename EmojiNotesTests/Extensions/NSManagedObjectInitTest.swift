//
//  NSManagedObjectInitTest.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 04/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
import CoreData
@testable import EmojiNotes


class NSManagedObjectInitTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNotePicture(){
        let cdm = CoreDataManagerMock()
        let notePicture : NotePicture
        notePicture = NotePicture(using: cdm.getMainManagedObjectContext()!)
        XCTAssertEqual(notePicture.entity.name, "NotePicture")
    }
    
    func testNote(){
        let cdm = CoreDataManagerMock()
        let notePicture : Note
        notePicture = Note(using: cdm.getMainManagedObjectContext()!)
        XCTAssertEqual(notePicture.entity.name, "Note")
    }
    
}
