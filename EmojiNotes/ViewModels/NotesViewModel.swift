//
//  NotesViewModel.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import CoreData

// inherit from NSOBject o conform to NSFetchedResultsControllerDelegate
public class NotesViewModel: NSObject {
    
//    var notes: [NSManagedObject]? {
//        didSet {
//            modelDidChange!(notes!)
//        }
//    }
    
//    public var modelDidChange: (([NSManagedObject])->Void)?
    public var modelDidChange: (()->Void)?

    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {

        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let fetchSort = NSSortDescriptor(key: #keyPath(Note.createdAt), ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager().getManagedObjectContext()!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        
        return fetchedResultsController
    }()
    
    func addNote() {
        let note = Note(context: CoreDataManager().getManagedObjectContext()!)
        note.contents = "Note contents"
        note.title = "Note title"
        note.createdAt = Date()
    }
    
    public func fetchNotes() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    
    
    override init() {
        super.init()
        fetchedResultsController.delegate = self
    }
    
}

extension NotesViewModel: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        notes = [fetchedResultsController.object(at: IndexPath(row: 0, section: 0))]
        modelDidChange!()

    }
    
}
