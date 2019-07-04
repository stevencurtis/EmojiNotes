//
//  ViewNoteViewModel.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 04/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
import CoreData
@testable import EmojiNotes

class ViewNoteViewModelTests: XCTestCase {

    func testNotesViewModel() {
        let cdm = CoreDataManagerMock()
        
        let notesViewModel = ViewNoteViewModel(cdm, cdm.getMainManagedObjectContext()!)
        let noteID = cdm.getTaskObjectIds().first!
        
        notesViewModel.update(noteID: noteID, title: "Changed Title")
        
        cdm.getMainManagedObjectContext()!.performAndWait {
            let request = NSFetchRequest<Note>(entityName: "Note")
            request.returnsObjectsAsFaults = false
            do {
                let result = try cdm.getMainManagedObjectContext()!.fetch(request)
                for data in result as [NSManagedObject] {
                    XCTAssertEqual(data.value(forKey: "title") as! String, "Changed Title")
                }
            } catch {
                print("Failed")
            }
        }
    }

    

}
