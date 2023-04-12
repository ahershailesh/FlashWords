//
//  Router.swift
//  SimpleApp
//
//  Created by Shazy on 29/03/23.
//

import Foundation

class Router {
    private let wordAPIExecuter = APIManager(host: "https://api.dictionaryapi.dev")
    private lazy var dataStorage: DataPersistance = { DataPersistance() }()
    private lazy var wordStorage: WordStorage = { WordStorage(persistance: dataStorage) }()
    private lazy var dictionary: DictionarySDK = { Dictionary(apiExecuter: wordAPIExecuter, storage: wordStorage) }()
    
    func getWordFlash() -> WordFlash {
        return WordFlash()
    }
    
    func getDictionarySearch() -> DictionarySearch {
        return DictionarySearch(viewModel: .init(), router: self)
    }
    
    func getWordDetail(for text: String) -> WordDetail {
        return WordDetail(
            viewModel: .init(
                word: "Color", dictionary: dictionary)
        )
    }
}
