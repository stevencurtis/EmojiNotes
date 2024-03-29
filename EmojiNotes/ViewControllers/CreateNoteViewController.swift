//
//  CreateNoteViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit
import CoreData

protocol CreateNoteDelegate {
    func provImage(_ img: UIImage)
}

protocol ChosenCategoryDelegate {
    func chosenCategory (_ category: Category)
}

protocol ChosenEmojiDelegate {
    func chosenEmoji (_ emoji: String )
}

class CreateNoteViewController: UIViewController, CreateNoteDelegate, ChosenCategoryDelegate, UITextViewDelegate, ChosenEmojiDelegate {

    @IBOutlet weak var chooseEmojiButton: UIButton!
    func chosenCategory(_ category: Category) {
        self.categoryName = category.name
        self.categoryColour = category.color as? UIColor
    }
    
    var emoji : String?
    var createNoteViewModel : CreateNoteViewModel?
    var image : UIImage?
    var coreDataManager: CoreDataManagerProtocol!
    var textViewClearedOnInitialEdit = false
    var chosenText: String?
    var categoryName: String?
    var categoryColour: UIColor?
    
    lazy var context : NSManagedObjectContext = {
        coreDataManager.getMainManagedObjectContext()
        }()!
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageLabel: UILabel!

    
    @IBAction func textViewDone(_ sender: UITextField) {
        chosenText = inputTextField.text
        sender.resignFirstResponder()
    }
    
    @objc func addImageView(_ sender:AnyObject){
        performSegue(withIdentifier: "selectImg", sender: sender)
    }
    
    @IBAction func chooseEmoji(_ sender: UIButton) {
        performSegue(withIdentifier: "emojiChooser", sender: sender)
    }
    
    @IBAction func addCategory(_ sender: UIButton) {
        createNoteViewModel?.getCategories{ categories in
            let sheet = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
            
            let newcat = UIAlertAction(title: "Create a new category", style: .default, handler: { action in
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

    override func willMove(toParent parent: UIViewController?) {
        if parent == nil {
            createNoteViewModel?.addNote(with: inputTextField.text, contents: contentTextView.text, emoji: emoji, img: image, categoryName: categoryName, categoryColour: categoryColour)
            coreDataManager.saveContext()

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImageView(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
                
        createNoteViewModel = CreateNoteViewModel(coreDataManager)
        
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
    
    // ------------ delegates ------------ //
    func chosenEmoji(_ emoji: String) {
        self.emoji = emoji
        emojiLabel.text = emoji
        chooseEmojiButton.setTitle("Change Emoji", for: .normal)
    }
    
    func provImage(_ img: UIImage) {
        image = img
        imageView.image = img
        imageLabel.text = "Click to change image"
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
                if let destination = segue.destination as? AddCategoryViewController {
                    destination.coreDataManager = coreDataManager
                    destination.context = context
                    destination.delegate = self
                    
                }
            } else {
                if segue.identifier == "emojiChooser" {
                    if let destination = segue.destination as? ChooseEmojiViewController
                    {
                        destination.delegate = self
                    }
                }
            }
        }
    }
    
}


