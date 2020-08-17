import Foundation

open class URLSessionProvider: ProviderProtocol {
    
    private var session: URLSessionProtocol
    
    public init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    @discardableResult
    public func request<T: Decodable>(service: ServiceProtocol, completion: @escaping (NetworkResponse<T>) -> ()) -> URLSessionDataTaskProtocol {
        let request = URLRequest(service: service)
        
        let task = session.dataTask(request: request, completionHandler: { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self?.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        })
        task.resume()
        return task
    }
    
    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (NetworkResponse<T>) -> ()) {
        guard error == nil else { return completion(.failure(.unknown)) }
        guard let response = response else { return completion(.failure(.noJSONData)) }
        
        switch response.statusCode {
        case 200...299:
            guard let data = data else {
                return completion(.failure(.unknown))
            }
            do {
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch {
                completion(.failure(.unknown))
            }
            
        default:
            completion(.failure(.unknown))
        }
    }
}
