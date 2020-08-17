import Foundation

public protocol ProviderProtocol {
    @discardableResult func request<T: Decodable>(service: ServiceProtocol, completion: @escaping (NetworkResponse<T>) -> ()) -> URLSessionDataTaskProtocol
}
