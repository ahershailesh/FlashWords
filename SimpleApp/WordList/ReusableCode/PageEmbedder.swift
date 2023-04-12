import Foundation

protocol PageEmbedderRepresentable {
    func set<Value>(page: Int, in request: Request<Value>) -> Request<Value>
}

final class PageEmbedder: PageEmbedderRepresentable {
    func set<Value>(page: Int, in request: Request<Value>) -> Request<Value> {
        var pageRequest = request
        pageRequest.query = request.query.merging([("page", page.description)], uniquingKeysWith: { lhs, _ in lhs })
        return pageRequest
    }
}
