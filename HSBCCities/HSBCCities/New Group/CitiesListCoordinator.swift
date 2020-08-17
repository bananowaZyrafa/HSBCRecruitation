import UIKit
import Coordinators

final class CitiesListCoordinator: BaseCoordinator {
    typealias Dependencies = HasCitiesListNetworkProvider & HasCityDetailsNetworkProvider & HasCityDetailsDataProvider & HasFavoriteManager
    
    private var dependencies: Dependencies
    
    init(presentationStyle: CoordinatorPresentationStyle = .root, dependencies: Dependencies) {
        self.dependencies = dependencies
        
        let navigationController = UINavigationController()
        let viewModel: CitiesListViewModel = CitiesListViewModel(dependencies: dependencies)
        let viewController = CitiesListViewController(viewModel: viewModel)
        self.dependencies.favoriteManager.synchronizatioinDelegate = viewModel
        navigationController.viewControllers = [viewController]
        
        super.init(viewController: navigationController, presentationStyle: presentationStyle)
        
        viewModel.coordinator = self
    }
    
    func presentDetails(ofCity cityViewModel: CityViewModel) {
        let coordinator = CityDetailsCoordinator(dependencies: dependencies, cityViewModel: cityViewModel)
        start(coordinator: coordinator)
    }
}

extension CitiesListCoordinator: CitiesListCoordinatorDelegate {
    func navigateToDetails(ofCity cityViewModel: CityViewModel) {
        presentDetails(ofCity: cityViewModel)
    }
}
