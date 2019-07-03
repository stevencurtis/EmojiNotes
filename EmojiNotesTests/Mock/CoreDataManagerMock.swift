//
//  CoreDataManagerMock.swift
//  EmojiNotesTests
//
//  Created by Steven Curtis on 03/07/2019.
//  Copyright © 2019 Steven Curtis. All rights reserved.
//

import Foundation
import CoreData
@testable import EmojiNotes


class CoreDataManagerMock: CoreDataManagerProtocol {
    
    // MARK: Properties
    private let modelName: String
    
    required init() {
        self.modelName = "EmojiNotes" //Constants.entityName
    }
    
    func saveContext() {
        //
    }
    
    func getMainManagedObjectContext() -> NSManagedObjectContext? {
        //
        return nil
    }
    
    func getChildManagedObjectContext() -> NSManagedObjectContext? {
        //
        return nil
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        //
    }
    


}
