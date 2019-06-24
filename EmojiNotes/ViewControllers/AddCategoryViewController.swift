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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoriesTableViewModel = CategoriesTableViewModel()
        // categories already fetched
//        categoriesTableViewModel?.fetchCategories()
    }
    @IBOutlet weak var existingColour: UILabel!
    @IBOutlet weak var existingCategory: UILabel!
    @IBOutlet weak var existingColourBlock: UIView!
    
    @IBAction func addExistingColour(_ sender: UIButton) {
        
        let colors = [UIColor.black, UIColor.darkGray, UIColor.lightGray, UIColor.white, UIColor.gray, UIColor.red, UIColor.green, UIColor.blue, UIColor.cyan, UIColor.yellow, UIColor.magenta, UIColor.orange, UIColor.purple, UIColor.brown]

        let sheet = UIAlertController(title: "Add Category", message: nil, preferredStyle: .actionSheet)
        
        for color in colors {
            let cat = UIAlertAction(title: (color).name, style: .default, handler: { action in
                self.existingColour.text = color.name
                self.existingColourBlock.backgroundColor = color
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
            }
        }
        
        ac.addAction(submitAction)
        
        present(ac, animated: true)
    }
    
    @IBAction func addExistingCategory(_ sender: UIButton) {
        enterCategory()
    }
    
    @IBAction func addCategory(_ sender: UIButton) {
    }
    
}
