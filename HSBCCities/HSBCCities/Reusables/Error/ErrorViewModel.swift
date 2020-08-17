import Foundation

final class ErrorViewModel {
    let title: String
    let description: String
    let tryAgainAction: (() -> Void)
    
    init(title: String, description: String, tryAgainAction: @escaping (() -> Void)) {
        self.title = title
        self.description = description
        self.tryAgainAction = tryAgainAction
    }
    
    init(error: Error, tryAgainAction: @escaping (() -> Void)) {
        self.title = "Something went wrong :("
        self.description = error.localizedDescription
        self.tryAgainAction = tryAgainAction
    }
}
