//
//  ViewController.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 21/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import UIKit
import CoreData

class NotesViewController: UIViewController {
    
    var notesViewModel : NotesViewModel?
    
    @IBOutlet weak var notesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesViewModel = NotesViewModel()
        
        notesViewModel?.modelDidChange = {
            self.notesCollectionView.reloadData()
        }
        
        notesViewModel?.fetchNotes()
        
        notesCollectionView.dataSource = self
        notesCollectionView.delegate = self

        let nib = UINib(nibName: "NotesCollectionViewCell", bundle: nil);
        notesCollectionView.register(nib, forCellWithReuseIdentifier: "NotesCollectionViewCell")
    }
    
//    @IBAction func addNote(_ sender: UIBarButtonItem) {
//        notesViewModel?.addNote()
//    }
}

extension NotesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (notesViewModel?.fetchedResultsController.sections![0].numberOfObjects)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotesCollectionViewCell", for: indexPath)
        cell.backgroundColor = .green
        
        if let note = notesViewModel?.fetchedResultsController.object(at: indexPath) {
            // configure the cell with the note
            print (
            note.title,
            note.createdAt

            )
        }
        return cell
    }
}

extension NotesViewController: UICollectionViewDelegate {
    
}



