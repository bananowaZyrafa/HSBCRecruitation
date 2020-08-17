import Foundation
import Networking

protocol CityDetailsNetworkProviderProtocol {
    @discardableResult
    func fetchCityVisitors(completion: @escaping ((NetworkResponse<[Visitor]>)) -> Void) -> URLSessionDataTaskProtocol
    @discardableResult
    func fetchCityRating(completion: @escaping ((NetworkResponse<Rating>)) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSessionProvider: CityDetailsNetworkProviderProtocol {
    @discardableResult
    func fetchCityRating(completion: @escaping ((NetworkResponse<Rating>)) -> Void) -> URLSessionDataTaskProtocol {
        return request(service: CityDetailsService.rating) { (response: NetworkResponse<CityRatingAPIResponse>) in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let apiResponse):
                completion(.success(apiResponse.rating))
            }
        }
    }
    @discardableResult
    func fetchCityVisitors(completion: @escaping ((NetworkResponse<[Visitor]>)) -> Void) -> URLSessionDataTaskProtocol {
        return request(service: CityDetailsService.visitors) { (response: NetworkResponse<CityVisitorsAPIResponse>) in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let apiResponse):
                completion(.success(apiResponse.visitors))
            }
        }
    }
}
