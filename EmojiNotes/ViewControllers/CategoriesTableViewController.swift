//
//  CategoriesTableViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 24/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class CategoriesTableViewController: UITableViewController {
private static let cellReuseId = "CatCell"
    var selectedCategory : String?
    
    var categoriesTableViewModel : CategoriesTableViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CategoriesTableViewController.cellReuseId)

        
        categoriesTableViewModel = CategoriesTableViewModel()
        categoriesTableViewModel?.fetchCategories()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addTapped))

    }
    
    @objc func addTapped() {
        // addCategory
        performSegue(withIdentifier: "addCategory", sender: nil)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addCategory" {
            if let destination = segue.destination as? AddCategoryViewController {
//                destination.
                
            }
        }
    }
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (categoriesTableViewModel?.fetchedResultsController.sections![0].numberOfObjects)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: CategoriesTableViewController.cellReuseId)
        if let category = categoriesTableViewModel?.fetchedResultsController.object(at: indexPath) {
            cell.textLabel?.text = "a" + (category.name ?? "")
            cell.detailTextLabel?.text =  (category.color as? UIColor)?.name! // "category.name"
            cell.backgroundColor = (category.color as? UIColor)
            
            let textColor = (category.color as? UIColor)!.isDarkColor ? UIColor.white : UIColor.black
            
            cell.detailTextLabel?.textColor = textColor
            cell.textLabel?.textColor = textColor

        }
        return cell
    }

}
