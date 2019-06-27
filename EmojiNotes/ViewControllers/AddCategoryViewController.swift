//
//  AddCategoryViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 24/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {
    
    var categoriesTableViewModel : CategoriesTableViewModel?
    var currentCategory : Category?
    var newCategory: String?
    var newColor: UIColor?
    
    var delegate: ChosenCategoryDelegate?
    
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var existingColour: UILabel!
    @IBOutlet weak var existingCategory: UILabel!
    @IBOutlet weak var existingColourBlock: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesTableViewModel = CategoriesTableViewModel()
        if currentCategory != nil {
            self.existingColour.text = (currentCategory?.color as? UIColor)?.name
            self.existingColourBlock.backgroundColor = currentCategory?.color as? UIColor
            self.newColor = currentCategory?.color as? UIColor
            self.existingCategory.text = currentCategory!.name ?? "No category name"
            self.newCategory = currentCategory!.name ?? "No category name"
            addCategoryButton.setTitle("Edit Category", for: .normal)
            self.title = "Edit Category"
        } else {
            self.title = "Edit Category"
        }
    }

    @IBAction func addExistingColour(_ sender: UIButton) {
        let colors = [UIColor.black, UIColor.darkGray, UIColor.lightGray, UIColor.white, UIColor.gray, UIColor.red, UIColor.green, UIColor.blue, UIColor.cyan, UIColor.yellow, UIColor.magenta, UIColor.orange, UIColor.purple, UIColor.brown]
        let sheet = UIAlertController(title: "Add Category", message: nil, preferredStyle: .actionSheet)
        for color in colors {
            let cat = UIAlertAction(title: (color).name, style: .default, handler: { action in
                self.existingColour.text = color.name
                self.existingColourBlock.backgroundColor = color
                self.newColor = color
                if let cat = self.newCategory, let col = self.newColor {
                    self.updateCategory(cat, col)
//                    delegate?.chosenCategory(<#T##category: Category##Category#>)
                }
            }
            )
            sheet.addAction(cat)            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cancel)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    func enterCategory() {
        let ac = UIAlertController(title: "Enter category", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            if let answer = ac.textFields?[0] {
                self.existingCategory.text = answer.text
                self.newCategory = answer.text
                if let cat = self.newCategory, let col = self.newColor {
                    self.updateCategory(cat, col)
                }
            }
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func addExistingCategory(_ sender: UIButton) {
        enterCategory()
    }
    
    func updateCategory(_ cat: String, _ col: UIColor) {
        if currentCategory == nil {
            let cat = (categoriesTableViewModel?.buildCategory(with: cat, colour: col))!
            if let delegate = delegate {
                delegate.chosenCategory(cat)
            }
        } else {
            categoriesTableViewModel?.updateCategory(with: currentCategory!, name: cat, colour: col)
        }

    }
    
    @IBAction func addCategory(_ sender: UIButton) {
        if let cat = newCategory, let col = newColor {
            updateCategory(cat, col)
        } else {
            let ac = UIAlertController(title: "Complete both the category and colour", message: nil, preferredStyle: .alert)
            let submitAction = UIAlertAction(title: "Done", style: .default)
            ac.addAction(submitAction)
            present(ac, animated: true)
        }
    }
    
}
