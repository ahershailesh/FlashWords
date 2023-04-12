//
//  DataPersistance.swift
//  SimpleApp
//
//  Created by Shazy on 29/03/23.
//

import Combine
import CoreData
import Foundation

class DataPersistance {
    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    init() {
        container = NSPersistentContainer(name: "WordCollection")
        container.loadPersistentStores { description, error in
            print(description)
        }
    }
}
