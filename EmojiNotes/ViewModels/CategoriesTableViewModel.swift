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
    
    var coreDataManager: CoreDataManagerProtocol!

    var context: NSManagedObjectContext!

    lazy var fetchedResultsController: NSFetchedResultsController<Category> = {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let fetchSort = NSSortDescriptor(key: #keyPath(Category.name), ascending: true)
        fetchRequest.sortDescriptors = [fetchSort]
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
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
    
    init(_ coreDataManager : CoreDataManagerProtocol, _ context: NSManagedObjectContext? = nil) {
        super.init()
        self.coreDataManager = coreDataManager
        if let context = context {
            self.context = context
        }
        fetchedResultsController.delegate = self
    }
    
    override init() {
        super.init()
        fetchedResultsController.delegate = self
    }
    
    private func addCategory(with name: String, colour: UIColor) {
        let _ = buildCategory(with: name, colour: colour)
//        coreDataManager.saveContext()
    }
    
    func buildCategory(with name: String, colour: UIColor) -> Category? {
        guard let moc = coreDataManager.getMainManagedObjectContext() else {return nil}
        let category = Category(context: moc)
        category.name = name
        category.color = colour
        return category
    }
    
    func updateCategory(with category: Category, name: String, colour: UIColor) {
        category.setValue(colour, forKey: "color")
        category.setValue(name, forKey: "name")
//        coreDataManager.saveContext()
    }
    
    func deleteCategory(category: Category) {
        guard let moc = coreDataManager.getMainManagedObjectContext() else {return}
        moc.delete(category)
//        coreDataManager.saveContext()
    }
    
    func updateCategory(noteObjectID: NSManagedObjectID, colourObjectID: NSManagedObjectID) {
        let category = context.object(with: colourObjectID) as? Category
        let pcNote = context.object(with: noteObjectID) as? Note
        pcNote!.setValue(category, forKey: "category")
//        context.perform {
//            do {
//                try self.context.save()
//            } catch _ as NSError {
//                fatalError()
//            }
//        }
    }
}

extension CategoriesTableViewModel: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let modelDidChange = modelDidChange {
            modelDidChange()
        }
    }

}
