//
//  ViewNoteViewModel.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 24/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import UIKit
import CoreData


public class ViewNoteViewModel {
    func update(note: Note, with category: Category? = nil, emoji: String? = nil, title: String? = nil, image: UIImage? = nil, content: String? = nil) {
        if let category = category {
            note.setValue(category, forKey: "category")
        }
        
        if let emoji = emoji {
            note.setValue(emoji, forKey: "emoji")
        }
        
        if let title = title {
            note.setValue(title, forKey: "title")
        }
        
        if let image = image {
            guard let moc = CoreDataManager().getManagedObjectContext() else {return}
            if let prevPic = note.picture {
                moc.delete(prevPic)
            }
            
            let notePicture = NotePicture(context: moc)
            notePicture.picture = image.pngData()
            notePicture.note = note            
            note.setValue(title, forKey: "title")
        }
        
        if let content = content {
            note.setValue(content, forKey: "contents")
        }
        
        CoreDataManager().saveContext()
    }

    
}
