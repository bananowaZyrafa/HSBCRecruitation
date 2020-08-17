import Foundation
@testable import Networking

enum FakeService: ServiceProtocol {
    case list
    
    var baseURL: URL {
        return URL(string: "www.google.com")!
    }
    
    var path: String {
        switch self {
        case .list:
            return ""
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
