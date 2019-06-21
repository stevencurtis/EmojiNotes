//
//  CreateNoteViewModel.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation

public class CreateNoteViewModel {
    init() {
        //
    }
    
    
    func addNote() {
        let note = Note(context: CoreDataManager().getManagedObjectContext()!)
        note.contents = "Note contents"
        note.title = "Note title"
        note.createdAt = Date()
        CoreDataManager().saveContext()
    }
    
}
