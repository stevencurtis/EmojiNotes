//
//  CreateNoteViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit

protocol CreateNoteDelegate {
    func provImage(_ img: UIImage)
}

protocol ChosenCategoryDelegate {
    func chosenCategory (_ category: Category)
}

class CreateNoteViewController: UIViewController, CreateNoteDelegate, ChosenCategoryDelegate, UITextViewDelegate {
    
    func chosenCategory(_ category: Category) {
        self.category = category
    }
    
    var category : Category?
    var createNoteViewModel : CreateNoteViewModel?
    var image : UIImage?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var chosenText: String?
    
    var categoryName: String?
    var categoryColour: UIColor?
    
    @IBAction func textViewDone(_ sender: UITextField) {
        chosenText = inputTextField.text
        sender.resignFirstResponder()
    }
    
    @IBAction func addCategory(_ sender: UIButton) {
        
        createNoteViewModel?.getCategories{ categories in
            print (categories)
            
            let sheet = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
            
            let newcat = UIAlertAction(title: "Create a new category", style: .default, handler: { action in
                print ("new selected")
                //addCat
                self.performSegue(withIdentifier: "addCat", sender: nil)
            }
            )
            
            for category in categories {
                let cat = UIAlertAction(title: category.name ?? "unnamed", style: .default, handler: { action in
                    self.categoryColour = category.color as? UIColor
                    self.categoryName = category.name
                }
                )
                sheet.addAction(cat)
            }
            sheet.addAction(newcat)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            sheet.addAction(cancel)
            self.present(sheet, animated: true, completion: nil)
        }
    }
    
    @IBAction func addNote(_ sender: UIButton) {
        createNoteViewModel?.addNote(with: chosenText ?? "untitled", contents: contentTextView.text, img: image, colour: categoryColour, catagoryName: categoryName)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        createNoteViewModel?.addNote(with: inputTextField.text ?? "untitled", contents: contentTextView.text, img: image, colour: categoryColour, catagoryName: categoryName)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNoteViewModel = CreateNoteViewModel()
        
        createNoteViewModel?.modelDidChange = {
            self.navigationController?.popViewController(animated: true)
        }
        
        contentTextView.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !self.textViewClearedOnInitialEdit {
            self.contentTextView.text = ""
            self.textViewClearedOnInitialEdit = true
        }
    }
    
    var textViewClearedOnInitialEdit = false
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            scrollView.contentInset = .zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
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
        } else {
            if segue.identifier == "addCat" {
                if let _ = segue.destination as? AddCategoryViewController {
                }
            }
        }
    }
    
    @IBAction func attachImage(_ sender: UIButton) {
    }
    
}


