//
//  Network.swift
//  SimpleApp
//
//  Created by Shazy on 23/03/23.
//

import Combine
import Foundation

protocol NetworkRepresentable {
    func execute<T: Decodable>(request: URLRequest, decoder: JSONDecoder) -> AnyPublisher<T, Error>
    func execute<T: Decodable>(api: API, decoder: JSONDecoder) -> AnyPublisher<T, Error>
}

final class Network: NetworkRepresentable {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    public func execute<T: Decodable>(request: URLRequest, decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        let publisher = PassthroughSubject<T, Error>()
        let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
            guard let data = data else {
                publisher.send(completion: .failure(error ?? NSError()))
                return
            }
            do {
                let object = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    publisher.send(object)
                }
            } catch let error {
                DispatchQueue.main.async {
                    publisher.send(completion: .failure(error))
                }
            }
        })
        
        dataTask.resume()
        return publisher.eraseToAnyPublisher()
    }
    
    public func execute<T: Decodable>(api: API, decoder: JSONDecoder = .init()) -> AnyPublisher<T, Error> {
        return execute(request: api.request(), decoder: decoder)
    }
}

enum HTTPMethod {
    case get, put(_ body: Encodable), post(_ body: Encodable)
}

protocol API {
    var hostURL: URL { get }
    
    var method: HTTPMethod { get }
    var path: String { get }
    var query: [String: String]? { get }
    var headers: [String: String]? { get }
    
    func request() -> URLRequest
}

extension API {
    var query: [String: String]? { nil }
    var headers: [String: String]? { nil }
    
    func request() -> URLRequest {
        var buildURL = hostURL.appending(path: path)
        if let query = query, !query.isEmpty {
            buildURL.append(queryItems: query.map { .init(name: $0, value: $1) })
        }
        var request = URLRequest(url: buildURL)
        request.allHTTPHeaderFields = headers
        return request
    }
}

enum DictionaryAPI {
    case definition(_ word: String)
}

extension DictionaryAPI: API {
    
    var hostURL: URL {
        URL(string: "https://api.dictionaryapi.dev")!
    }
    
    var path: String {
        switch self {
        case let .definition(word):
            return "/api/v2/entries/en/\(word)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}

enum SuggestionAPI {
    case suggestions(_ word: String)
}

extension SuggestionAPI: API {
    var hostURL: URL {
        URL(string: "https://api.datamuse.com")!
    }
    
    var path: String {
        switch self {
        case .suggestions:
            return "/sug"
        }
    }
    
    var query: [String : String]? {
        switch self {
        case let .suggestions(word):
            return ["s": word]
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}
