import Foundation
import Networking

enum CityDetailsService: ServiceProtocol {
    case visitors
    case rating
    
    var baseURL: URL {
        return URL(string: NetworkingConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .visitors:
            return NetworkingConstants.CityDetails.visitorsEndpoint
        case .rating:
            return NetworkingConstants.CityDetails.ratingEndpoint
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var headers: Headers? {
        return nil
    }
    
    var parametersEncoding: ParametersEncoding {
        return .url
    }
}
