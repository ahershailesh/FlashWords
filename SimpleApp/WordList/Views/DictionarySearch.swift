//
//  DictionarySearch.swift
//  SimpleApp
//
//  Created by Shazy on 19/03/23.
//

import SwiftUI

struct DictionarySearch: View {
    @ObservedObject var viewModel: DictionarySearchViewModel
    private let router: Router
    
    init(viewModel: DictionarySearchViewModel, router: Router) {
        self.viewModel = viewModel
        self.router = router
    }

    @FocusState private var keyboardFocused: Bool
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search",
                          text: $viewModel.query)
                .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 8))
                .border(.gray, width: 1)
                .cornerRadius(4)
                .keyboardType(.webSearch)
                .focused($keyboardFocused)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        keyboardFocused = true
                    }
                }
                List(viewModel.suggestions, id: \.self) { item in
                    NavigationLink {
                        router.getWordDetail(for: item)
                    } label: {
                        Text(item)
                    }
                }
                .listStyle(.plain)
                Spacer()
            }
            .padding()
        }
    }
}

struct DictionarySearch_Previews: PreviewProvider {
    static var previews: some View {
        DictionarySearch(viewModel: .init(), router: .init())
    }
}
