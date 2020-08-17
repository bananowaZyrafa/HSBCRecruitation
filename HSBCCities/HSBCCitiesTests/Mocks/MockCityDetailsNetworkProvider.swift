import Foundation
import Networking

@testable import HSBCCities

final class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    func resume() {}
    func cancel() {}
}

final class MockCityDetailsNetworkProvider: CityDetailsNetworkProviderProtocol {
    var shouldVisitorsResponseSucceed: Bool
    var visitorsResponse: [Visitor]
    
    var shouldRatingResponseSucceed: Bool
    var ratingResponse: Rating
    
    var waitTime: TimeInterval
    
    static let instance: MockCityDetailsNetworkProvider = MockCityDetailsNetworkProvider(shouldVisitorsResponseSucceed: false, visitorsResponse: [], shouldRatingResponseSucceed: false, ratingResponse: .init(avgRating: 0.0, maxRating: 0.0), waitTime: 0.0)
    
    init(shouldVisitorsResponseSucceed: Bool, visitorsResponse: [Visitor] = MockResponses.visitors,
         shouldRatingResponseSucceed: Bool, ratingResponse: Rating = MockResponses.rating,
         waitTime: TimeInterval) {
        self.shouldVisitorsResponseSucceed = shouldVisitorsResponseSucceed
        self.visitorsResponse = visitorsResponse
        
        self.shouldRatingResponseSucceed = shouldRatingResponseSucceed
        self.ratingResponse = ratingResponse
        
        self.waitTime = waitTime
    }
 
    @discardableResult
    func fetchCityVisitors(completion: @escaping ((NetworkResponse<[Visitor]>)) -> Void) -> URLSessionDataTaskProtocol {
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) { [weak self] in
            guard let self = self else { return }
            if self.shouldVisitorsResponseSucceed {
                completion(.success(self.visitorsResponse))
            } else {
                completion(.failure(.unknown))
            }
        }
        return MockURLSessionDataTask()
    }
    
    @discardableResult
    func fetchCityRating(completion: @escaping ((NetworkResponse<Rating>)) -> Void) -> URLSessionDataTaskProtocol {
        DispatchQueue.main.asyncAfter(deadline: .now() + waitTime) { [weak self] in
            guard let self = self else { return }
            if self.shouldRatingResponseSucceed {
                completion(.success(self.ratingResponse))
            } else {
                completion(.failure(.unknown))
            }
        }
        return MockURLSessionDataTask()
    }
}
