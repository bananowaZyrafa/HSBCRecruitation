import Foundation
import Networking

enum CitiesListService: ServiceProtocol {
    case list
    
    var baseURL: URL {
        return URL(string: NetworkingConstants.baseURL)!
    }
    
    var path: String {
        switch self {
        case .list:
            return NetworkingConstants.CitiesList.listEndpoint
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
