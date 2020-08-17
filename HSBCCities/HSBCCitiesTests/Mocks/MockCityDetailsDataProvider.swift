import Foundation
import Networking

@testable import HSBCCities
class MockCityDetailsDataProvider: CityDetailsDataProviderProtocol {
    var shouldSucceed: Bool
    var successResponse: CityDetails
    var waitTime: TimeInterval
    
    init(shouldSucceed: Bool, successResponse: CityDetails = MockResponses.cityDetails, waitTime: TimeInterval) {
        self.shouldSucceed = shouldSucceed
        self.successResponse = successResponse
        self.waitTime = waitTime
    }
    
    func fetchCityDetails(for city: City, queue: DispatchQueue, completion: @escaping ((NetworkResponse<CityDetails>)) -> Void) {
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
