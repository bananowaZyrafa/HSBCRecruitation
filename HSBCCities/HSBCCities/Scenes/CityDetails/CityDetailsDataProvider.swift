import Foundation
import Networking

protocol CityDetailsDataProviderProtocol {
    func fetchCityDetails(for city: City, queue: DispatchQueue, completion: @escaping ((NetworkResponse<CityDetails>)) -> Void)
}

final class CityDetailsDataProvider: CityDetailsDataProviderProtocol {
    typealias Dependencies = CityDetailsNetworkProviderProtocol
    
    private let dependencies: Dependencies
    private var ongoingDataTasks: [URLSessionDataTaskProtocol] = []
    
    private let operationQueue = OperationQueue()
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func fetchCityDetails(for city: City, queue: DispatchQueue, completion: @escaping ((NetworkResponse<CityDetails>)) -> Void) {
        var rating: NetworkResponse<Rating>?
        var visitors: NetworkResponse<[Visitor]>?
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        
        let dataTask1 = dependencies.fetchCityRating { response in
            rating = response
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        let dataTask2 = dependencies.fetchCityVisitors { response in
            visitors = response
            dispatchGroup.leave()
        }
        ongoingDataTasks.append(contentsOf: [dataTask1, dataTask2])
        dispatchGroup.notify(queue: .main) {
            switch (rating, visitors) {
            case let (.some(.success(rating)), .some(.success(visitors))):
                let cityDetails = CityDetails(visitors: visitors, rating: rating, city: city)
                completion(.success(cityDetails))
            default:
                completion(.failure(.unknown))
            }
        }
    }
    
    deinit {
        ongoingDataTasks.forEach { $0.cancel() }
    }
}
