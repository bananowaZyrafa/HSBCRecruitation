import UIKit
import Coordinators

final class AppCoordinator: BootstrapCoordinator {
    
    private let window: UIWindow
    var subcoordinators: [Coordinator] = []
    private let dependencies: Dependencies
    
    init(window: UIWindow, dependencies: Dependencies) {
        self.window = window
        self.dependencies = dependencies
    }
    
    func start() {
        let coordinator = CitiesListCoordinator(dependencies: dependencies)
        start(coordinator: coordinator, with: window, animated: true)
    }
}
