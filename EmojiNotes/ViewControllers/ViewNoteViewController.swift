//
//  ViewNoteViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 24/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit
import CoreData

protocol CategoryViewNote {
    func updateCategories(category: Category, name: String)
}

class ViewNoteViewController: UIViewController, CategoryViewNote, CreateNoteDelegate, ChosenEmojiDelegate {
    
    var coreDataManager: CoreDataManager!
    var viewNoteViewModel : ViewNoteViewModel?
    
    var context: NSManagedObjectContext!
    
    var noteObjectID: NSManagedObjectID!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBAction func chooseEmoji(_ sender: UIButton) {
        performSegue(withIdentifier: "chooseEmoji", sender: sender)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        performSegue(withIdentifier: "editCategories", sender: sender)
    }
    
    @IBAction func chooseTitle(_ sender: UIButton) {
        let ac = UIAlertController(title: "Enter new title", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            if let answer = ac.textFields?[0] {
                self.viewNoteViewModel?.update(noteID: self.noteObjectID, title: answer.text)
                self.titleLabel.text = answer.text
            }
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @IBAction func chooseContent(_ sender: UIButton) {
        let ac = UIAlertController(title: "Enter your new content", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned ac] _ in
            if let answer = ac.textFields?[0] {
                    self.viewNoteViewModel?.update(noteID: self.noteObjectID, content: answer.text)
                    self.contentLabel.text = answer.text
            }
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    // --------- Delegate functions --------------
    func chosenEmoji(_ emoji: String) {
        emojiLabel.text = emoji
        
        viewNoteViewModel?.update(noteID: noteObjectID, emoji: emoji)
    }
    
    func provImage(_ img: UIImage) {
        imageView.image = img
        imageLabel.text = "Click to change image"
        imageView.backgroundColor = .clear
        viewNoteViewModel?.update(noteID: noteObjectID, image: img)
    }

    func updateCategories(category: Category, name: String) {
        colourLabel.text = (category.color as! UIColor).name
        categoryLabel.text = category.name
        colourLabel.backgroundColor = (category.color as! UIColor)
        let textColor = (category.color as! UIColor).isDarkColor ? UIColor.white : UIColor.black
        colourLabel.textColor = textColor
    }
    
    //-----//
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCategories" {
            if let destination = segue.destination as? CategoriesTableViewController {
                destination.coreDataManager = coreDataManager
                destination.noteObjectID = noteObjectID
                destination.context = context
                destination.delegate = self
            }
        } else {
            if segue.identifier == "editImage" {
                if let destination = segue.destination as? AttachPhotoViewController {
                    destination.noteDelegate = self
                }
            } else {
                if segue.identifier == "chooseEmoji" {
                    if let destination = segue.destination as? ChooseEmojiViewController
                    {
                        destination.delegate = self
                    }
                }
            }
        }
    }
    
    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            // back button pressed, save the child class and pass back to the main context for saving
            coreDataManager.saveContext()
        }
    }
    
    // prepare UI
    func prepView() {
        if let note = context.object(with: noteObjectID!) as? Note {
            if let img = note.picture!.picture {
                imageView.image = UIImage(data: img)
                imageLabel.text = "Click to change image"
                imageView.backgroundColor = .clear
            }
            titleLabel.text = note.title ?? "No title"
            emojiLabel.text = note.emoji ?? "No emoji"
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
        viewNoteViewModel = ViewNoteViewModel(coreDataManager, context)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editImageView(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        prepView()
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
    
    @objc func editImageView(_ sender:AnyObject){
        performSegue(withIdentifier: "editImage", sender: sender)
    }
}
