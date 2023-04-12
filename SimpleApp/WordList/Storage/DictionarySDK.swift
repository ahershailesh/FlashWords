//
//  DictionarySDK.swift
//  SimpleApp
//
//  Created by Shazy on 29/03/23.
//

import Combine

protocol DictionarySDK {
    func meaning(of word: String) -> AnyPublisher<WordDefinition, Error>
}

class Dictionary: DictionarySDK {
    private let apiExecuter: APIExecutable
    private let storage: WordStorable
    
    init(apiExecuter: APIExecutable, storage: WordStorable) {
        self.apiExecuter = apiExecuter
        self.storage = storage
    }
    
    func meaning(of text: String) -> AnyPublisher<WordDefinition, Error> {
        if let word = storage.getWord(text) {
            return Just(word)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return apiExecuter.execute(Request<[WordDefinition]>(method: .get, path: "/api/v2/entries/en/\(text)"))
            .map { [weak self] output in
                self?.storage.saveWord(text, definition: output.first!)
                return output.first!
            }
            .eraseToAnyPublisher()
    }
    
    func bookmark(word: String) {
        
    }
}
