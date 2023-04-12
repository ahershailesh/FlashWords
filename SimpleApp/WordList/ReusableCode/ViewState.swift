import Foundation

enum ViewState<DATA> {
    case loading, empty, data(dataArray: [DATA]), error
    
    var data: [DATA]? {
        if case .data(let dataArray) = self {
            return dataArray
        }
        return nil
    }
}
