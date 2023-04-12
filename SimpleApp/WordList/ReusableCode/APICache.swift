import Combine
import Foundation

final class APICache: APIExecutable {
    private let fileHandler: FileLoadable
    
    init(fileHandler: FileLoadable = FileHandler()) {
        self.fileHandler = fileHandler
    }
    
    func execute<Value: Decodable>(_ request: Request<Value>) -> AnyPublisher<Value, Error> {
        let filePath: String

        switch (request.method, request.path) {
        case (.get, "/tunes"):
            filePath = "get_tunes"
        case (.post, "tunes"):
            filePath = "post_tunes"
        case (.get, "/movie/238/similar"):
            filePath = "similar_movies"
        case (.get, "genre/movie/list"):
            filePath = "genres"
        case (_, _):
            filePath = "WordDefinition"
        }
        guard let data = fileHandler.load(fileName: filePath) else {
            return Fail(error: APIError.networkError)
                .eraseToAnyPublisher()
        }
        do {
            let response = try JSONDecoder().decode(Value.self, from: data)
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: APIError.parsingError)
                .eraseToAnyPublisher()
        }
    }
}
