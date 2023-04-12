import Foundation

enum Method {
    case get
    case post
    
    var value: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        }
    }
}

struct Request<Value> {
    var method: Method
    var path: String
    var query: [String: String]
    var body: Encodable?
    
    init(method: Method = .get, path: String, query: [String: String] = [:], body: Encodable? = nil) {
        self.method = method
        self.path = path
        self.query = query
        self.body = body
    }
}
