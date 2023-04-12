//
//  DictionarySearchViewModel.swift
//  SimpleApp
//
//  Created by Shazy on 25/03/23.
//

import Combine
import Foundation

struct SuggestionModel: Decodable {
    let word: String
}

final class DictionarySearchViewModel: ObservableObject {
    @Published var selection: String?
    @Published var suggestions: [String] = []
    @Published var query: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var searchTimer: Timer?
    private let network: Network
    
    init(network: Network = .init()) {
        self.network = network
        $query
            .removeDuplicates()
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .sink { [weak self] input in
                if !input.isEmpty {
                    self?.executeSuggestions(text: input)
                } else {
                    self?.suggestions = []
                }
        }.store(in: &cancellables)
    }
    
    private func executeSuggestions(text: String) {
        let publisher: AnyPublisher<[SuggestionModel], Error> = network.execute(api: SuggestionAPI.suggestions(text))
        publisher
            .map { $0.map { $0.word } }
            .replaceError(with: [])
            .assign(to: &$suggestions)
    }
}
