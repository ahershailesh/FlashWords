//
//  WordDetail.swift
//  SimpleApp
//
//  Created by Shazy on 19/03/23.
//

import SwiftUI

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

struct Pill: View {
    let text: String
    let backgroundColor: Color
    
    var body: some View {
        Text(text)
            .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
            .background(backgroundColor)
            .cornerRadius(4)
            .foregroundColor(.white)
            .bold()
    }
}

struct VericleDashText: View {
    let text: String
    
    var body: some View {
        HStack {
            VStack {
                Rectangle()
                    .frame(width: 2)
                    .foregroundColor(.init(uiColor: .lightGray))
            }
            VStack {
                TextWithTitle(title: "Example: ", text: text)
                    .lineLimit(3)
                    .italic()
            }
        }
    }
}

struct TextWithTitle: View {
    
    let title: String
    let text: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Color(.init(rgb: 0x848482)))
            +
            Text(text)
            Spacer()
        }
    }
}

struct MeaningView: View {
    let meanings: [Meaning]
    
    var body: some View {
        LazyVGrid(columns: [.init(.flexible())]) {
            ForEach(meanings, id: \.partOfSpeech) { item in
                VStack {
                    HStack {
                        Pill(text: item.partOfSpeech, backgroundColor: Color(.init(rgb: 0xD77C5A)))
                        Spacer()
                    }
                    
                    ForEach(item.definitions, id: \.definition) { definition in
                        
                        VStack(alignment: .leading) {
                            TextWithTitle(title: "Definition: ", text: definition.definition)
                            
                            if let example = definition.example {
                                VericleDashText(text: example)
                            }
                            
                            if !definition.synonyms.isEmpty {
                                HorizontalGrid(title: "Synonyms: ", items: definition.synonyms)
                            }
                            
                            if !definition.antonyms.isEmpty {
                                HorizontalGrid(title: "Antonyms: ", items: definition.synonyms)
                            }
                        }
                        .padding(.vertical)
                        
                        if item.definitions.last?.definition != definition.definition {
                            Divider()
                        }
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .background(Color(.init(rgb: 0xc9e9e4)))
            .cornerRadius(8)
        }
    }
}

struct PhoneticView: View {
    let phonetics: [Phonetic]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(phonetics, id: \.text) { item in
                HStack {
                    Text(item.text ?? "pronounciation")
                        .foregroundColor(.orange)
                    if !item.audio.isEmpty {
                        Button {
                            print("Audio Played")
                        } label: {
                            Image(systemName: "speaker.wave.3.fill")
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

struct HorizontalGrid: View {
    let title: String
    let items: [String]

    var body: some View {
            HStack {
                Text(title)
                    .foregroundColor(Color(.init(rgb: 0x848482)))
                ScrollView(.horizontal) {
                    LazyHGrid(rows: [GridItem(.flexible())], alignment: .center, spacing: 4) {
                        ForEach(items, id: \.self) { item in
                            Button {
                                print(item)
                            } label: {
                                if items.last != item {
                                    Text(item + ",")
                                        .underline()
                                } else {
                                    Text(item)
                                        .underline()
                                }
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
            }
            .scrollIndicators(.hidden)
    }
}

struct WordDetail: View {
    @ObservedObject private var viewModel: WordDetailViewModel
    
    init(viewModel: WordDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            switch viewModel.state {
            case .loading:
                Text("Loading")
            case let .error(text):
                Text(text)
            case let .data(definitions):
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(definitions, id: \.word) { definition in
                        PhoneticView(phonetics: definition.phonetics)
                               
                        ScrollView {
                            MeaningView(meanings: definition.meanings)
                        }
                        .cornerRadius(8)
                    }
                }
                .padding()
                case let .empty(text):
                    Text(text)
            }
        }
        .navigationBarTitle("Color")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("Remember Tapped")
                } label: {
                    Image(systemName: "bookmark")
                }
            }
        }
    }
}

struct WordDetail_Previews: PreviewProvider {
    static var previews: some View {
        WordDetail(
            viewModel: .init(
                word: "Color",
                dictionary: Dictionary(apiExecuter: APIManager(host: "https://api.dictionaryapi.dev"),
                                       storage: WordStorage(persistance: DataPersistance())
                )
            )
        )
        .tabItem {
            Label("Search", systemImage: "rectangle.stack.badge.play")
        }
        
        
        WordFlash()
            .tabItem {
                Label("Practice", systemImage: "rectangle.stack.badge.play")
            }

    }
}
