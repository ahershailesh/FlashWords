import Combine
import Foundation

enum APIError: Error {
    case networkError
    case parsingError
}

extension URL {
    func url(with queryItems: [URLQueryItem]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)!
        components.queryItems = (components.queryItems ?? []) + queryItems
        return components.url!
    }
    
    init<Value>(_ host: String, _ request: Request<Value>) {
        let queryItems =
        request.query.map { name, value in URLQueryItem(name: name, value: "\(value)") }
        let url = URL(string: host)!
            .appendingPathComponent(request.path)
            .url(with: queryItems)
        
        self.init(string: url.absoluteString)!
    }
}

protocol APIExecutable {
    func execute<Value: Decodable>(_ request: Request<Value>) -> AnyPublisher<Value, Error>
}

final class APIManager: APIExecutable {
    private let authKey: String?
    private let host: String
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared,
         host: String,
         authKey: String? = nil) {
        self.host = host
        self.authKey = authKey
        self.urlSession = urlSession
    }
    
    func execute<Value: Decodable>(_ request: Request<Value>) -> AnyPublisher<Value, Error> {
        return URLSession.DataTaskPublisher(request: urlRequest(for: request), session: urlSession)
            .tryMap({ data, _ in
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                return try jsonDecoder.decode(Value.self, from: data)
            })
            .eraseToAnyPublisher()
    }
    
    private func urlRequest<Value>(for request: Request<Value>) -> URLRequest {
        let url = URL(host, request)
        var result = URLRequest(url: url)
        result.httpMethod = request.method.value
        if let body = request.body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            result.httpBody = try? encoder.encode(body)
        }
        result.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        result.setValue(authKey, forHTTPHeaderField: "Authorization")
        return result
    }
}
