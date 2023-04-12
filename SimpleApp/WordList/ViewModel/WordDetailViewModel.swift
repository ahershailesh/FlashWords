//
//  WordDetailViewModel.swift
//  SimpleApp
//
//  Created by Shazy on 25/03/23.
//

import Combine
import Foundation
import CoreData

final class WordDetailViewModel: ObservableObject {
    enum State {
        case loading, error(String), data([WordDefinition]), empty(String)
    }
    
    @Published var state: State = .loading
    private var cancellables = Set<AnyCancellable>()
    let word: String
    let dictionary: DictionarySDK
    
    init(word: String, dictionary: DictionarySDK) {
        self.word = word
        self.dictionary = dictionary
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.getDefintion(text: word)
        }
    }
    
    private func getDefintion(text: String) {
        state = .loading
        dictionary.meaning(of: text)
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                case let .failure(error):
                    self?.state = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] value in
                self?.state = .data([value])
            }.store(in: &cancellables)
    }
}
