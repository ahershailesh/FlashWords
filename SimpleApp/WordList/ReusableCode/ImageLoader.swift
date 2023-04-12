//
//  ImageLoader.swift
//  Avatar
//
//  Created by Shazy on 01/02/23.
//

import Combine
import Foundation
import SwiftUI
import UIKit

class ImageLoader: ObservableObject {
    private let session: URLSession
    
    init(session: URLSession) {
        session.configuration.requestCachePolicy = .reloadRevalidatingCacheData
        session.configuration.urlCache = .init()
        self.session = session
    }
    
    func update(url: String) -> AnyPublisher<Data, URLError> {
        guard let url = URL(string: url) else { return Fail(error: URLError(.badURL)).eraseToAnyPublisher() }
        return session.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}

struct RemoteImage: View {
    @State private var image: UIImage?
    private let urlString: String
    private let placeholderName: String?

    init(urlString: String, placeholderName: String?) {
        self.urlString = urlString
        self.placeholderName = placeholderName
    }
    
    var body: some View {
        Image(uiImage: image ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .background(Color.red)
            .onAppear(perform: loadImage)
    }
    
    private func loadImage() {
        guard let url = URL(string: urlString) else {
            setPlaceHolder()
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    self.image = image
                } else {
                    setPlaceHolder()
                }
            }
        }.resume()
    }
    
    private func setPlaceHolder() {
        guard let placeholderImageName = placeholderName else { return }
        print("Placeholder set \(placeholderImageName)")
        self.image = UIImage(named: placeholderImageName)
    }
}

struct CardDescriptionView: View {
    let imageURL: String
    let placeholderName: String?
    let description: String
    
    var body: some View {
        VStack(alignment: .leading) {
            RemoteImage(urlString: imageURL, placeholderName: placeholderName)
                .frame(width: 300, height: 200)
                .cornerRadius(10)
                .shadow(radius: 10)
            
            Text(description)
                .font(.subheadline)
                .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}
