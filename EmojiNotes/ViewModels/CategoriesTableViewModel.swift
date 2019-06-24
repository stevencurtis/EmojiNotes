//
//  CategoriesTableViewModel.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 24/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import CoreData

public class CategoriesTableViewModel: NSObject {
    
    public var modelDidChange: (()->Void)?

    lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let fetchSort = NSSortDescriptor(key: #keyPath(Category.note), ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: CoreDataManager().getManagedObjectContext()!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
    }()
    
    public func fetchCategories() {
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

extension CategoriesTableViewModel: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        modelDidChange!()
    }
}
