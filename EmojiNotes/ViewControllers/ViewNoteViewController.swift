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
    }
    
    func provImage(_ img: UIImage) {
        imageView.image = img
    }
    
    var viewNoteViewModel : ViewNoteViewModel?
    var note: Note?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var colourLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var emojiLabel: UILabel!
    
    @IBAction func chooseEmoji(_ sender: UIButton) {
        performSegue(withIdentifier: "chooseEmoji", sender: sender)
    }
    
    @IBAction func editButton(_ sender: UIButton) {
        performSegue(withIdentifier: "editCategories", sender: sender)
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
            } else {
                imageView.isHidden = true
            }
            titleLabel.text = note.title!
            emojiLabel.text = note.emoji!
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
