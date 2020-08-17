import Foundation
import Networking

protocol CitiesListNetworkProviderProtocol {
    func fetchCityList(completion: @escaping ((NetworkResponse<[City]>) -> Void))
}

extension URLSessionProvider: CitiesListNetworkProviderProtocol {
    func fetchCityList(completion: @escaping ((NetworkResponse<[City]>) -> Void)) {
        request(service: CitiesListService.list) { (response: NetworkResponse<CitiesListAPIResponse>) -> Void in
            switch response {
            case .failure(let error):
                completion(.failure(error))
            case .success(let apiResponse):
                completion(.success(apiResponse.cities))
            }
        }
    }
}
