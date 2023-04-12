import Foundation

protocol FileLoadable {
    func load(fileName: String) -> Data?
}

class FileHandler: FileLoadable {
    func load(fileName: String) -> Data? {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "json"),
              let data = try? String(contentsOfFile: filePath).data(using: .utf8) else {
            return nil
        }
        return data
    }
    
    func load<T: Decodable>(fileName: String, decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = load(fileName: fileName) else { return nil }
        return try? decoder.decode(T.self, from: data)
    }
}
