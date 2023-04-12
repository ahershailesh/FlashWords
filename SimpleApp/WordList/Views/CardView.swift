//
//  CardView.swift
//  SimpleApp
//
//  Created by Shazy on 18/03/23.
//

import SwiftUI

struct CardView: View {
    var person: String
    
    @State private var offset = CGSize.zero
    @State private var color: Color = .black
    @State private var showDefinition = false
    
    var body: some View {
        VStack {
            if showDefinition {
                HStack {
                    Text("an expression or gesture of greeting —used interjectionally in greeting, in answering the telephone, or to express surprise")
                }
                .padding()
                .background(.blue.opacity(0.3))
                .cornerRadius(8)
            }
            Spacer()
            ZStack {
                Rectangle()
                    .frame(width: 320, height: 420)
                    .border(.white, width: 6.0)
                    .cornerRadius(4)
                    .foregroundColor(color.opacity(0.9))
                    .shadow(radius: 4)
                
                HStack {
                    Text(person)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .bold()
                }
            }
            .offset(x: offset.width, y: offset.height * 0.4)
            .rotationEffect(.degrees(Double(offset.width / 40)))
            .gesture(
                DragGesture()
                    .onChanged {
                        offset = $0.translation
                        changeColor(width: offset.width)
                        showDefinition = true
                    }
                    .onEnded { _ in
                        withAnimation {
                            swipeCard(width: offset.width)
                        }
                        showDefinition = false
                    }
            )
            Spacer()
        }
    }
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            print("\(person) removed")
            offset = CGSize(width: -500, height: 0)
        case 150...500:
            print("\(person) added")
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
            color = .black
        }
    }
    
    func changeColor(width: CGFloat) {
        switch width {
        case -500...(-50):
            color = .red
        case 50...500:
            color = .green
        default:
            color = .black
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(person: "Mario")
    }
}
