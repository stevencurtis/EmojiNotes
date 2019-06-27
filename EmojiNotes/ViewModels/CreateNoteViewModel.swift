//
//  CreateNoteViewModel.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import UIKit
import CoreData

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
    
    func addNote(with title: String, contents: String, emoji: String, img: UIImage? = nil, colour: UIColor? = nil, catagoryName: String? = nil) {
        guard let moc = CoreDataManager().getManagedObjectContext() else {return}
        guard contents != "Enter your note" else {return}
        
        let note = Note(context: moc)
        note.contents = ( (contents == "Enter your note") ? "Untitled" : contents )
        note.title = title
        note.createdAt = Date()
        note.contents = contents
        note.emoji = emoji

        let notePicture = NotePicture(context: moc)
        notePicture.picture = img?.pngData()
        notePicture.note = note
        
        let category = Category(context: moc)
        category.name = catagoryName
        category.color = colour
        note.category = category
        
        CoreDataManager().saveContext()
    }
    
    func addNote(with title: String, contents: String, emoji: String? = nil, img: UIImage? = nil, category: Category? = nil) {
        guard let moc = CoreDataManager().getManagedObjectContext() else {return}
        guard contents != "Enter your note" else {return}
        
        let note = Note(context: moc)
        note.contents = ( (contents == "Enter your note") ? "Untitled" : contents )
        note.title = title
        note.createdAt = Date()
        note.contents = contents
        note.emoji = emoji
        
        let notePicture = NotePicture(context: moc)
        notePicture.picture = img?.pngData()
        notePicture.note = note
        note.category = category
        
        CoreDataManager().saveContext()
        
    }
    
    func getCategories(closure : @escaping ((_ result: [Category])->Void) ) {
        guard let moc = CoreDataManager().getManagedObjectContext() else {return}
        let commitFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        let asyncFetchRequest = NSAsynchronousFetchRequest<Category>(
        fetchRequest: commitFetchRequest) { (result: NSAsynchronousFetchResult) in
            guard let categories = result.finalResult else {
                return
            }
            closure(categories)
        }
        
        do {
            try moc.execute(asyncFetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }

    
}
