//
//  ViewNoteViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 24/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

public struct SimpleNote {
    var content: String?
    var image: UIImage?
    var title: String?
}

class ViewNoteViewController: UIViewController {
    var viewNoteViewModel : ViewNoteViewModel?
    var note: SimpleNote?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func editButton(_ sender: UIButton) {
        performSegue(withIdentifier: "editCategories", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCategories" {
            if let destination = segue.destination as? CategoriesTableViewController {
                destination.selectedCategory = "AA"
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewNoteViewModel = ViewNoteViewModel()
        
        if let note = note {
            imageView.image = note.image
            titleLabel.text = note.title
        }

    }
    


}
