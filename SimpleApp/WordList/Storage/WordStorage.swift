//
//  WordStorage.swift
//  SimpleApp
//
//  Created by Shazy on 29/03/23.
//

import Combine
import CoreData
import Foundation

protocol WordStorable {
    func getWord(_ text: String) -> WordDefinition?
    func saveWord(_ text: String, definition: WordDefinition)
    func bookmark(word: String)
    func getBookmarks() -> [String]
}

class WordStorage: WordStorable {
    func getBookmarks() -> [String] {
        []
    }
    
    private let persistance: DataPersistance
    
    init(persistance: DataPersistance) {
        self.persistance = persistance
    }
    
    func getWord(_ text: String) -> WordDefinition? {
        let fetchRequest = NSFetchRequest<WordCache>(entityName: "WordCache")
        fetchRequest.predicate = NSPredicate(format: "word == %@", text)
        do {
            if let data = try persistance.viewContext.fetch(fetchRequest).first?.data {
                let word = try JSONDecoder().decode(WordDefinition.self, from: data)
                return word
            }
        } catch let error {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func saveWord(_ text: String, definition: WordDefinition) {
        let item = WordCache(context: persistance.viewContext)
        item.word = text
        do {
            item.data = try JSONEncoder().encode(definition)
            try persistance.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func bookmark(word: String) {
        
    }
    
//    func getBookmarks() -> [String] {
//        let fetchRequest = NSFetchRequest<WordCache>(entityName: "WordList")
//        do {
//            if let data = try persistance.viewContext.fetch(fetchRequest) {
//                let word = try JSONDecoder().decode(WordDefinition.self, from: data)
//                return word
//            }
//        } catch let error {
//            print(error.localizedDescription)
//        }
//        return []
//    }
}
