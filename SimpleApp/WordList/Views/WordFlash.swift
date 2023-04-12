//
//  WordFlash.swift
//  SimpleApp
//
//  Created by Shazy on 17/03/23.
//

import Combine
import SwiftUI

struct WordFlash: View {
    
    private let people: [String] = ["Shailesh", "Sunil", "Akshay"]
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(people, id: \.self) { person in
                    CardView(person: person)
                }
            }
        }
    }
}

struct WordFlash_Previews: PreviewProvider {
    static var previews: some View {
        WordFlash()
    }
}
