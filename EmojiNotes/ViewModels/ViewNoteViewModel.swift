//
//  ViewNoteViewModel.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 24/06/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import UIKit
import CoreData


public class ViewNoteViewModel {
    func update(note: Note, with category: Category) {
        note.setValue(category, forKey: "category")
        CoreDataManager().saveContext()
    }
}
