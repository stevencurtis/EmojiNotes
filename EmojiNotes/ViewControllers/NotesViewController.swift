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
    
    var notesViewModel : NotesViewModel?
    
    @IBOutlet weak var notesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesViewModel = NotesViewModel()
        
        notesViewModel?.modelDidChange = {
            self.notesCollectionView.reloadData()
        }
        
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notesCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func basicAdd(_ sender: UIBarButtonItem) {
        let note = Note(context: CoreDataManager().getManagedObjectContext()!)
        note.contents = "Add contents"
        note.title = "Add title"
        note.createdAt = Date()
        
        let notePicture = NotePicture(context: CoreDataManager().getManagedObjectContext()!)
        notePicture.picture = UIImage(named: "PT")!.pngData()
        notePicture.note = note
        
        CoreDataManager().saveContext()

    }
}

extension NotesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (notesViewModel?.fetchedResultsController.sections![0].numberOfObjects)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionViewCell", for: indexPath) as! NotesCollectionViewCell
        
        if let note = notesViewModel?.fetchedResultsController.object(at: indexPath) {
            // configure the cell with the note
            if let picture = note.picture?.picture{
                cell.configure(title: note.title ?? "Untitled", colour: UIColor.blue, image: UIImage(data: picture )  )
            } else {
                cell.configure(title: note.title ?? "Untitled", colour: UIColor.orange)
            }
        }
        return cell
    }

}

extension NotesViewController: UICollectionViewDelegate {
    
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


