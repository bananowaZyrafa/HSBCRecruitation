import UIKit

open class BaseCoordinator: NSObject, Coordinator {
    public weak var parentCoordinator: Coordinator?
    public var presentationStyle: CoordinatorPresentationStyle
    public var viewController: UIViewController
    public var subcoordinators: [Coordinator] = []

    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        controller.presentedViewController.modalPresentationStyle
    }

    public init(viewController: UIViewController,
         presentationStyle: CoordinatorPresentationStyle) {
        self.viewController = viewController
        self.presentationStyle = presentationStyle
        super.init()
    }

    public func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController, animated: Bool) {
        if let coordinator = findCoordinator(forViewController: viewController) {
            coordinator.subcoordinators.removeAll()
            navigationController.delegate = coordinator
        }
    }

    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        subcoordinators.removeAll()
        removeFromParentCoordinator()
    }
}
