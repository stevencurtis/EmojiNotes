//
//  CategoriesTableViewModel.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 24/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
    
    private func addCategory(with name: String, colour: UIColor) {
        let _ = buildCategory(with: name, colour: colour)
        CoreDataManager().saveContext()
    }
    
    func buildCategory(with name: String, colour: UIColor) -> Category? {
        guard let moc = CoreDataManager().getManagedObjectContext() else {return nil}
        let category = Category(context: moc)
        category.name = name
        category.color = colour
        return category
    }
    
    
    func updateCategory(with category: Category, name: String, colour: UIColor) {
        category.setValue(colour, forKey: "color")
        category.setValue(name, forKey: "name")
        CoreDataManager().saveContext()

    }
    
}

extension CategoriesTableViewModel: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        modelDidChange!()
    }
}
