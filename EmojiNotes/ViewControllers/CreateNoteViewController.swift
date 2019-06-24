//
//  CreateNoteViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

protocol CreateNoteDelegate {
    func provImage( _ img: UIImage)
}

class CreateNoteViewController: UIViewController, CreateNoteDelegate {
    
    var createNoteViewModel : CreateNoteViewModel?
    var image : UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var chosenText: String?
    
    var category: String?
    var categoryColour: UIColor?
    
    @IBAction func textViewDone(_ sender: UITextField) {
        chosenText = inputTextField.text
        sender.resignFirstResponder()
    }
    
    @IBAction func addCategory(_ sender: UIButton) {
        
        let sheet = UIAlertController(title: "Add Category", message: nil, preferredStyle: .actionSheet)
        let study = UIAlertAction(title: "Study", style: .default, handler: { action in
            self.categoryColour = UIColor.purple
            self.category = "Study"
        }
        )
        
        let work = UIAlertAction(title: "Work", style: .default, handler: { action in
            self.categoryColour = UIColor.blue
            self.category = "Work"
        }
        )
        
        sheet.addAction(study)
        sheet.addAction(work)
        
        self.present(sheet, animated: true, completion: nil)

    }
    
    @IBAction func addNote(_ sender: UIButton) {
        createNoteViewModel?.addNote(with: chosenText ?? "untitled", img: image, colour: categoryColour, catagoryName: category)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNoteViewModel = CreateNoteViewModel()
        
        createNoteViewModel?.modelDidChange = {
            print ("Resign this view")
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    func provImage(_ img: UIImage) {
        image = img
        imageView.image = img
    }
    
    @IBAction func attachImg(_ sender: UIButton) {
        performSegue(withIdentifier: "selectImg", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectImg" {
            if let destination = segue.destination as? AttachPhotoViewController {
                destination.noteDelegate = self
            }
        }
    }
    
    @IBAction func attachImage(_ sender: UIButton) {
    }
    
}
