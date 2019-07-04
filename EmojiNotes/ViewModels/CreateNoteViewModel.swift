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
    
    // closure so if the model has changed, we know to pop the vc
    public var modelDidChange: (()->Void)?
    
    var coreDataManager: CoreDataManagerProtocol!

    @objc func notificationReceived (withNotification notification: NSNotification) {
        DispatchQueue.main.async {
            self.modelDidChange!()
        }
    }
    
    // a method of adding the note here is injecting the entities. This means changing production code for testing! In every other
    // case like this tests are using mocks, since mocking core data manager means we do not have to change production code
    func addNote(with title: String? = nil, contents: String, emoji: String? = nil, img: UIImage? = nil, categoryName: String? = nil, categoryColour: UIColor? = nil, noteEntity: NSEntityDescription? = nil, pictureEntity: NSEntityDescription? = nil, categoryEntity: NSEntityDescription? = nil) {
        guard let moc = coreDataManager.getMainManagedObjectContext() else {return}
        guard contents != "Enter your note" else {return}
        let note: Note

        if let noteEntity = noteEntity {
            note = Note(entity: noteEntity, insertInto: moc)
        } else {
            note = Note(using: moc)
        }
        note.contents = ( (contents == "Enter your note") ? "No contents" : contents )
        note.title = ( (title! == "") ? "Titleless note" : title)
        note.createdAt = Date()
        note.emoji = emoji
        note.updatedAt = Date()
        
        let notePicture : NotePicture // = NotePicture(context: moc)
        
        if let pictureEntity = pictureEntity {
            notePicture = NotePicture(entity: pictureEntity, insertInto: moc)
        } else {
            notePicture = NotePicture(using: moc)
        }
        
        notePicture.picture = img?.pngData()
        notePicture.note = note
        
        
        let category : Category
        
        if let categoryEntity = categoryEntity {
            category = Category(entity: categoryEntity, insertInto: moc)
        } else {
            category = Category(using: moc)
        }
        
        category.color = categoryColour
        category.name = categoryName
        
        note.category = category
    }
    
    func getCategories(closure : @escaping ((_ result: [Category])->Void) ) {
        guard let moc = coreDataManager.getMainManagedObjectContext() else {return}
        let commitFetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        let asyncFetchRequest = NSAsynchronousFetchRequest<Category>(fetchRequest: commitFetchRequest) { (result: NSAsynchronousFetchResult) in
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
    
    init(_ coreDataManager : CoreDataManagerProtocol) {
        self.coreDataManager = coreDataManager
    }

    
}
