import UIKit

public protocol Coordinator: ParentCoordinator, UINavigationControllerDelegate, UIAdaptivePresentationControllerDelegate, NSObject {
    var parentCoordinator: Coordinator? { get set } // ALWAYS WEAK
    var presentationStyle: CoordinatorPresentationStyle { get set }
    var viewController: UIViewController { get }
    var navigationController: UINavigationController? { get }

    func pop(coordinator: Coordinator)
    func removeFromParentCoordinator()
    func findCoordinator(forViewController viewController: UIViewController) -> Coordinator?

    func insert(coordinator: Coordinator?)
    func removeSubcoordinators()
    func start(coordinator: Coordinator, with style: CoordinatorPresentationStyle?, animated: Bool)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

extension Coordinator {
    public var navigationController: UINavigationController? {
        return viewController as? UINavigationController ?? viewController.navigationController ?? parentCoordinator?.viewController.navigationController
    }

    public func pop(coordinator: Coordinator) {
        guard let index = subcoordinators.firstIndex(where: { $0 === coordinator }) else { return }
        subcoordinators.remove(at: index)
        coordinator.navigationController?.delegate = self
    }

    public func removeFromParentCoordinator() {
        parentCoordinator?.pop(coordinator: self)
    }

    public func findCoordinator(forViewController viewController: UIViewController) -> Coordinator? {
        weak var parentCoordinator: Coordinator? = self.parentCoordinator
        while let coordinator = parentCoordinator {
            if viewController === coordinator.viewController {
                return coordinator
            }
            parentCoordinator = coordinator.parentCoordinator
        }
        return nil
    }

    public func insert(coordinator: Coordinator? = nil) {
        if let coordinator = coordinator {
            coordinator.parentCoordinator = self
            subcoordinators.append(coordinator)
        }
        coordinator?.navigationController?.delegate = coordinator
    }

    public func removeSubcoordinators() {
        subcoordinators.forEach {
            $0.removeSubcoordinators()
        }
        subcoordinators.removeAll()
    }

    public func start(coordinator: Coordinator, with style: CoordinatorPresentationStyle? = nil, animated: Bool = true) {
        let presentationStyle = style ?? coordinator.presentationStyle
        switch presentationStyle {
        case .push:
            navigationController?.pushViewController(coordinator.viewController, animated: animated)
        case .modal:
            let navigation = UINavigationController(rootViewController: coordinator.viewController)
            navigation.presentationController?.delegate = coordinator
            viewController.present(navigation, animated: true, completion: nil)
        case .modalFullscreen(let createRoot):
            let childViewController = createRoot ? UINavigationController(rootViewController: coordinator.viewController) : coordinator.viewController
            childViewController.presentationController?.delegate = coordinator
            childViewController.modalPresentationStyle = .fullScreen
            viewController.present(childViewController, animated: true, completion: nil)
        case .root:
            navigationController?.delegate = coordinator
            navigationController?.setViewControllers([coordinator.viewController], animated: animated)
            removeSubcoordinators()
        case .none:
            break
        }
        insert(coordinator: coordinator)
    }

    public func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {

        let finalize = { [weak self] in
            self?.subcoordinators.removeAll()
            completion?()
            self?.removeFromParentCoordinator()
        }

        switch presentationStyle {
        case .push:
            navigationController?.popViewController(animated: true)
            finalize()
        case .modal, .modalFullscreen:
            navigationController?.dismiss(animated: animated, completion: {
                finalize()
            })
        case .root, .none:
            finalize()
        }
    }
}
