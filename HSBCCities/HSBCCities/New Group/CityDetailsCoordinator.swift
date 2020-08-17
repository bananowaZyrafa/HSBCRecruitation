import Foundation
import Coordinators

final class CityDetailsCoordinator: BaseCoordinator {
    typealias Dependencies = HasCityDetailsNetworkProvider & HasCityDetailsDataProvider & HasFavoriteManager
    
    init(presentationStyle: CoordinatorPresentationStyle = .push, dependencies: Dependencies, cityViewModel: CityViewModel) {
        let viewModel = CityDetailsViewModel(dependencies: dependencies, cityViewModel: cityViewModel)
        let viewController = CityDetailsViewController(viewModel: viewModel)
        super.init(viewController: viewController, presentationStyle: presentationStyle)
        viewModel.coordinator = self 
    }
    
    func presentVisitors(visitors: [Visitor]) {
//        let coordinator = CityVisitorsCoordinator(presentationStyle: .modal, visitors: visitors)
//        start(coordinator: coordinator)
    }
}

extension CityDetailsCoordinator: CityDetailsCoordinatorDelegate {
    func navigateToDetails(ofVisitors visitors: [Visitor]) {
        presentVisitors(visitors: visitors)
    }
}
