//
//  CategoriesTableViewModelTests.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 04/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import XCTest
import CoreData
@testable import EmojiNotes

class CategoriesTableViewModelTests: XCTestCase {

    func testDeleteCategoryViewModel() {
        let cdm = CoreDataManagerMock()
        let categoriesTableViewModel = CategoriesTableViewModel(cdm, cdm.getMainManagedObjectContext()!)
        categoriesTableViewModel.fetchCategories()
        categoriesTableViewModel.deleteCategory(category: cdm.getCategories().first! as! EmojiNotes.Category)
        categoriesTableViewModel.modelDidChange = {
            XCTAssertEqual(categoriesTableViewModel.fetchedResultsController.fetchedObjects!.count, 0)
        }
    }
    
    func testUpdateCategoryViewModel() {
        let cdm = CoreDataManagerMock()
        let categoriesTableViewModel = CategoriesTableViewModel(cdm, cdm.getMainManagedObjectContext()!)
        categoriesTableViewModel.fetchCategories()
        categoriesTableViewModel.updateCategory(with: cdm.getCategories().first! as! EmojiNotes.Category, name: "changed Name", colour: UIColor.red)
        categoriesTableViewModel.modelDidChange = {
            XCTAssertEqual(categoriesTableViewModel.fetchedResultsController.fetchedObjects!.first?.name, "changed Name")
        }
    }
    
    func testUpdateCategoryWithIDViewModel() {
        let cdm = CoreDataManagerMock()
        
        let categoriesTableViewModel = CategoriesTableViewModel(cdm, cdm.getMainManagedObjectContext()!)
        categoriesTableViewModel.fetchCategories()
        
        categoriesTableViewModel.updateCategory(noteObjectID: cdm.getTaskObjectIds().first! , colourObjectID: cdm.getCategoryIds().first!)
        
        
        categoriesTableViewModel.modelDidChange = {
            XCTAssertEqual((categoriesTableViewModel.fetchedResultsController.fetchedObjects!.first?.color as! EmojiNotes.Category).name, "changed Name")
        }
    }
    
    func testBuildCatagoryViewModel() {
        let cdm = CoreDataManagerMock()
        
        let categoriesTableViewModel = CategoriesTableViewModel(cdm, cdm.getMainManagedObjectContext()!)
        let cats = categoriesTableViewModel.buildCategory(with: "test cat", colour: UIColor.purple)
        XCTAssertEqual(cats?.name, "test cat")
    }
    


}
