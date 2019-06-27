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

class ViewNoteViewController: UIViewController, CategoryViewNote, CreateNoteDelegate, ChosenEmojiDelegate {
    func chosenEmoji(_ emoji: String) {
        emojiLabel.text = emoji
        if let note = note {
            viewNoteViewModel?.update(note: note, emoji: emoji)
        }
    }
    
    func provImage(_ img: UIImage) {
        imageView.image = img
        imageLabel.text = "Click to change image"
        imageView.backgroundColor = .clear
        if let note = note {
            viewNoteViewModel?.update(note: note, image: img)
        }
    }
    
    var viewNoteViewModel : ViewNoteViewModel?
    var note: Note?
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
                if let note = self.note {
                    self.viewNoteViewModel?.update(note: note, title: answer.text)
                    self.titleLabel.text = answer.text
                }
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
                if let note = self.note {
                    self.viewNoteViewModel?.update(note: note, content: answer.text)
                    self.contentLabel.text = answer.text
                }
            }
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }

    
    func updateCategories(category: Category) {
        if let note = note {
            viewNoteViewModel?.update(note: note, with: category)
        }
        self.note?.category = category
        self.categoryLabel.text = category.name
        self.colourLabel.text = (category.color as? UIColor)?.name
        
        colourLabel.backgroundColor = (category.color as? UIColor)
        let textColor = (category.color as? UIColor)!.isDarkColor ? UIColor.white : UIColor.black
        colourLabel.textColor = textColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editCategories" {
            if let destination = segue.destination as? CategoriesTableViewController {
                destination.selectedCategory = "AA"
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
    
    func prepView() {
        if let note = note {
            if let img = note.picture?.picture {
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
        viewNoteViewModel = ViewNoteViewModel()
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
