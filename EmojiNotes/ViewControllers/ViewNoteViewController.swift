//
//  ViewNoteViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 24/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

protocol CategoryViewNote {
    func updateCategories(category: Category)
}

class ViewNoteViewController: UIViewController, CategoryViewNote {
    var viewNoteViewModel : ViewNoteViewModel?
//    var note: SimpleNote?
    var note: Note?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
        
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBAction func editButton(_ sender: UIButton) {
        performSegue(withIdentifier: "editCategories", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCategories" {
            if let destination = segue.destination as? CategoriesTableViewController {
                destination.selectedCategory = "AA"
                destination.delegate = self
            }
        }
    }
    
    func updateCategories(category: Category) {
        if let note = note {
            viewNoteViewModel?.update(note: note, with: category)
        }
        self.note?.category = category
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let note = note {
            if let img = note.picture?.picture {
                imageView.image = UIImage(data: img)
            } else {
                imageView.isHidden = true
            }
            titleLabel.text = note.title
            contentLabel.text = note.contents
            if let noteColor = note.category?.color as? UIColor {
                colourLabel.text = noteColor.name
                colourLabel.backgroundColor = noteColor
                let textColor = noteColor.isDarkColor ? UIColor.white : UIColor.black
                colourLabel.textColor = textColor
            }
            categoryLabel.text = (note.category?.name ?? "No category name")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNoteViewModel = ViewNoteViewModel()

    }
    


}
