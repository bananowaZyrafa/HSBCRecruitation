import Foundation

public protocol URLSessionDataTaskProtocol: class {
    func resume()
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}
