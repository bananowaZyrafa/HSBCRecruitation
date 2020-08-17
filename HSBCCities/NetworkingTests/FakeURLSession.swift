import Foundation
@testable import Networking

class FakeURLSession: URLSessionProtocol {
    let dataTaskResult: (Data?, URLResponse?, Error?)
    
    init(dataTaskResult: (Data?, URLResponse?, Error?)) {
        self.dataTaskResult = dataTaskResult
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        completionHandler(dataTaskResult.0, dataTaskResult.1, dataTaskResult.2)
        return FakeURLSessionDataTask()
    }
}
