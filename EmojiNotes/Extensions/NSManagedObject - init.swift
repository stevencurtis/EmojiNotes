//
//  NSManagedObject - init.swift
//  EmojiNotes
//
//  Created by Steven Curtis on 04/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import CoreData

// This is a new convenience initiailzer as recommended from https://github.com/drewmccormack/ensembles/issues/275
public extension NSManagedObject {
    convenience init(using context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
