import Foundation

protocol CityVisitorsViewModelProtocol {
    var visitorsNames: [String] { get }
    func close()
}

protocol CityVisitorsCoordinatorProtocol: class {
    func close()
}

final class CityVisitorsViewModel: CityVisitorsViewModelProtocol {
    private let visitors: [Visitor]
    weak var coordinator: CityVisitorsCoordinatorProtocol?
    
    var visitorsNames: [String] {
        visitors.map { $0.name }
    }
    
    init(visitors: [Visitor]) {
        self.visitors = visitors
    }
    
    func close() {
        coordinator?.close()
    }
}
