import UIKit

public protocol BootstrapCoordinator: ParentCoordinator {
    func start(coordinator: Coordinator, with window: UIWindow, animated: Bool)
}

public extension BootstrapCoordinator {
    func start(coordinator: Coordinator, with window: UIWindow, animated: Bool = false) {
        window.rootViewController = coordinator.viewController
        window.makeKeyAndVisible()
        subcoordinators = [coordinator]
        if animated {
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
