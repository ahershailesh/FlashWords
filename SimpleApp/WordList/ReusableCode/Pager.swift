import Foundation

protocol PagerRepresentable {
    func getNextPage<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void)
    func getPrevPage<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void)
}

protocol APIExecutablePager {
    func execute<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void)
}

final class Pager: PagerRepresentable {
    private(set) var currentPage: Int = Pager.START_PAGE
    private var nextPage: Int {
        return currentPage + 1
    }
    private var prevPage: Int {
        guard currentPage > 1 else { return 1 }
        return currentPage - 1
    }
    let apiExecuter: APIExecutablePager
    let pageEmbedder: PageEmbedder
    
    init(currentPage: Int, apiExecuter: APIExecutablePager, pageEmbedder: PageEmbedder = .init()) {
        self.currentPage = currentPage
        self.apiExecuter = apiExecuter
        self.pageEmbedder = pageEmbedder
    }
    
    func getNextPage<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void) {
        let modifiedRequest = pageEmbedder.set(page: nextPage, in: request)
        
        
        
        
        apiExecuter.execute(modifiedRequest) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_): self.currentPage = self.currentPage + 1
            default: break
            }
            completion(result)
        }
    }
    
    func getPrevPage<Value: Decodable>(_ request: Request<Value>, completion: @escaping (Result<Value, APIError>) -> Void) {
        let modifiedRequest = pageEmbedder.set(page: prevPage, in: request)
        apiExecuter.execute(modifiedRequest, completion: completion)
    }
}

extension Pager {
    static var START_PAGE: Int {
        return 0
    }
}
