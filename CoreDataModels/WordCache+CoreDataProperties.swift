//
//  WordCache+CoreDataProperties.swift
//  SimpleApp
//
//  Created by Shazy on 29/03/23.
//
//

import Foundation
import CoreData

extension WordCache {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WordCache> {
        return NSFetchRequest<WordCache>(entityName: "WordCache")
    }

    @NSManaged public var word: String?
    @NSManaged public var data: Data?

}

extension WordCache : Identifiable {

}
