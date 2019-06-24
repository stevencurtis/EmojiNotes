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
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived(withNotification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    public var modelDidChange: (()->Void)?

    @objc func notificationReceived (withNotification notification: NSNotification) {
        DispatchQueue.main.async {
            self.modelDidChange!()
        }
    }
    
    func addNote(with title: String, img: UIImage? = nil, colour: UIColor? = nil, catagoryName: String? = nil) {
        
        guard let moc = CoreDataManager().getManagedObjectContext() else {return}
        
        let note = Note(context: moc)
        note.contents = "Note contents"
        note.title = title
        note.createdAt = Date()

        let notePicture = NotePicture(context: moc)
        notePicture.picture = img?.pngData()
        notePicture.note = note
        
        let category = Category(context: moc)
        category.name = catagoryName
        category.color = colour
        note.category = category
        
        CoreDataManager().saveContext()

    }
    
}
