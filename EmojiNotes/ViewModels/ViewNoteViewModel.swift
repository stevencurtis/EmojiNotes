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
    
    var coreDataManager: CoreDataManagerProtocol!
    var context: NSManagedObjectContext!
    
    func update(noteID: NSManagedObjectID, with category: Category? = nil, emoji: String? = nil, title: String? = nil, image: UIImage? = nil, content: String? = nil) {
        
        let note = context.object(with: noteID)
        if let category = category {
            let cat = context.object(with: category.objectID) as! Category
            note.setValue(cat, forKey: "category")
        }
        
        if let emoji = emoji {
            note.setValue(emoji, forKey: "emoji")
        }
        
        if let title = title {
            note.setValue(title, forKey: "title")
        }
        
        if let image = image {
            if let prevPic = (note as! Note).picture {
                context.delete(prevPic)
            }            
            let notePicture = NotePicture(context: context)
            notePicture.picture = image.pngData()
            notePicture.note = (note as! Note)
        }
        
        if let content = content {
            note.setValue(content, forKey: "contents")
        }
        
        coreDataManager.saveContext(context)
        
    }
    
    init(_ coreDataManager : CoreDataManager, _ context: NSManagedObjectContext) {
        self.coreDataManager = coreDataManager
        self.context = context
    }
    
}
