//
//  NotesViewModelTests.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 04/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
import CoreData
@testable import EmojiNotes


class NotesViewModelTests: XCTestCase {

    func testNotesViewModel() {
        let cdm = CoreDataManagerMock()
        let notesViewModel = NotesViewModel(cdm)
        notesViewModel.fetchNotes()
        XCTAssertEqual(notesViewModel.fetchedResultsController.fetchedObjects!.count, 1)
    }
    
    func testDeleteNotesViewModel() {
        let cdm = CoreDataManagerMock()
        let notesViewModel = NotesViewModel(cdm)
        notesViewModel.fetchNotes()
        let noteID = notesViewModel.fetchedResultsController.fetchedObjects!.first!.objectID
        notesViewModel.deleteNote(noteID)
        
        notesViewModel.modelDidChange = {
            XCTAssertEqual(notesViewModel.fetchedResultsController.fetchedObjects!.count, 0)

        }
    }
    
}
