//
//  NotesViewModel.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import CoreData

// inherit from NSObject to conform to NSFetchedResultsControllerDelegate
public class NotesViewModel: NSObject {

    public var modelDidChange: (()->Void)?
    
    var coreDataManager: CoreDataManagerProtocol!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Note> = {
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        let fetchSort = NSSortDescriptor(key: #keyPath(Note.createdAt), ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: coreDataManager.getMainManagedObjectContext()!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
    }()
    
    public func fetchNotes() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Unable to Perform Fetch Request")
            print("\(error), \(error.localizedDescription)")
        }
    }
    
    init(_ coreDataManager : CoreDataManagerProtocol) {
        super.init()
        self.coreDataManager = coreDataManager
        fetchedResultsController.delegate = self
    }
    
    func deleteNote(_ nodeID: NSManagedObjectID) {
        guard let moc = coreDataManager.getMainManagedObjectContext() else {return}
        moc.delete(moc.object(with: nodeID))
        // save the deletion. Ideally you'd give the user an "are you sure" dialogue for an important note!
        coreDataManager.saveContext()
    }
    
}

extension NotesViewModel: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        modelDidChange!()
    }
}
