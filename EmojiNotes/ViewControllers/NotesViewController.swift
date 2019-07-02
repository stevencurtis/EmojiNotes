//
//  ViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var noNotesSV: UIStackView!
    @IBOutlet weak var notesCollectionView: UICollectionView!

    var notesViewModel : NotesViewModel?
    
    // a boolean to store if the cells are shaking - because if they are we can't traverse to the view screen
    var shaking = false

    let coreDataManager = CoreDataManager()
    
    @IBAction func createNote(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "createNote", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesViewModel = NotesViewModel(coreDataManager)
        notesViewModel?.modelDidChange = {
            self.notesCollectionView.reloadData()
        }
        
        // view model fetches the notes from the NSFetchedResultsControllerDelegate
        notesViewModel?.fetchNotes()
        
        notesCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        notesCollectionView.dataSource = self
        notesCollectionView.delegate = self
        
        // must also be set in IB
        if let layout = notesCollectionView?.collectionViewLayout as? TwoColumnLayout {
            layout.delegate = self
        }
        
        let nib = UINib(nibName: "NotesCollectionViewCell", bundle: nil);
        notesCollectionView.register(nib, forCellWithReuseIdentifier: "NotesCollectionViewCell")
        
        // Long press recognizer for the notes
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.allowableMovement = 15 // 15 points
        longPressGesture.delegate = self
        self.notesCollectionView.addGestureRecognizer(longPressGesture)    }
    
    @objc func longPressed(sender: UILongPressGestureRecognizer)
    {
        
        if sender.state == UIGestureRecognizer.State.ended {
            return
        }
        else if sender.state == UIGestureRecognizer.State.began
        {
            let p = sender.location(in: self.notesCollectionView)
            let indexPath = self.notesCollectionView.indexPathForItem(at: p)
            
            if let index = indexPath {
                if let note = notesViewModel?.fetchedResultsController.object(at: index) {
                    if shaking {
                        notesViewModel?.deleteNote(note.objectID)
                    }
                }
            } else {
                // not on a cell
                for cell in notesCollectionView!.visibleCells {
                    if let cell = cell as? NotesCollectionViewCell {
                        cell.stopShaking()
                    }
                }
                shaking = false
                return
            }

            for cell in notesCollectionView!.visibleCells {
                if let cell = cell as? NotesCollectionViewCell {
                    cell.shake()
                }
            }
            shaking = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // reloaded as the data may have changed on the view note screen
        self.notesCollectionView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notesCollectionView.collectionViewLayout.invalidateLayout()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNote" {
            if let destination = segue.destination as? ViewNoteViewController {
                if let note = notesViewModel?.fetchedResultsController.object(at: (sender as! IndexPath) ) {
                    // here to use a childContext. This child context is wholly for amending objects
                    destination.coreDataManager = coreDataManager
                    
                    let myNoteEntity = coreDataManager.childManagedObjectContext.object(with: note.objectID) as! Note
                    destination.context = coreDataManager.childManagedObjectContext
                    destination.noteObjectID = myNoteEntity.objectID
                }
            }
        } else if segue.identifier == "createNote" {
            if let destination = segue.destination as? CreateNoteViewController {
                destination.coreDataManager = coreDataManager
            }
        }
    }
}

extension NotesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let numberResults = (notesViewModel?.fetchedResultsController.sections![0].numberOfObjects) {
            (numberResults == 0) ? (noNotesSV.isHidden = false) : (noNotesSV.isHidden = true)
            return numberResults
        }
        noNotesSV.isHidden = false
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionViewCell", for: indexPath) as! NotesCollectionViewCell
        
        if let note = notesViewModel?.fetchedResultsController.object(at: indexPath) {
            
            let colour = note.category?.color

            // configure the cell with the note
            if let picture = note.picture?.picture{                
                cell.configure(title: note.title ?? "Untitled", colour: (colour as? UIColor) ?? UIColor.blue, emoji: note.emoji, image: UIImage(data: picture )  )
            } else {
                cell.configure(title: note.title ?? "Untitled", colour: (colour as? UIColor) ?? UIColor.orange, emoji: note.emoji)
            }
        }
        return cell
    }
}

extension NotesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !shaking {
            performSegue(withIdentifier: "showNote", sender: indexPath)
        }
    }
}

//MARK: - TwoColumnLayoutDelegate
extension NotesViewController : TwoColumnLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, imgSize indexPath:IndexPath) -> CGFloat {
        if let note = notesViewModel?.fetchedResultsController.object(at: indexPath) {
            if let _ = note.picture?.picture{
                return 100
            }
            return 25
        }
        return 0
    }
}

extension NotesViewController: UIGestureRecognizerDelegate {}
