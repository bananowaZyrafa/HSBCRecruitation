import Foundation
import Networking

@testable import HSBCCities
final class MockCitiesListNetworkProvider: CitiesListNetworkProviderProtocol {
    var shouldSucceed: Bool
    var successResponse: [City]
    var waitTime: TimeInterval
    
    init(shouldSucceed: Bool, successResponse: [City], waitTime: TimeInterval) {
        self.shouldSucceed = shouldSucceed
        self.successResponse = successResponse
        self.waitTime = waitTime
    }
    
    func fetchCityList(completion: @escaping ((NetworkResponse<[City]>) -> Void)) {
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) { [weak self] in
            guard let self = self else { return }
            if self.shouldSucceed {
                completion(.success(self.successResponse))
            } else {
                completion(.failure(.unknown))
            }
        }
    }
}
