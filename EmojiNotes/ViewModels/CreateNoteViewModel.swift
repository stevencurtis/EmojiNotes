//
//  CreateNoteViewModel.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import UIKit

public class CreateNoteViewModel {
    init() {
        //
    }
    
    
    func addNote(with title: String, img: UIImage? = nil) {
        let note = Note(context: CoreDataManager().getManagedObjectContext()!)
        note.contents = "Note contents"
        note.title = title
        note.createdAt = Date()
        CoreDataManager().saveContext()
        
        let notePicture = NotePicture(context: CoreDataManager().getManagedObjectContext()!)
        notePicture.picture = img?.pngData()
        notePicture.note = note
    }
    
}
