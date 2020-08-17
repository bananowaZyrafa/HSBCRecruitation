import Foundation

public protocol ParentCoordinator: class {
    var subcoordinators: [Coordinator] { get set }
    func subcoordinator<T>(ofType coordinatorType: T.Type) -> T? where T: Coordinator
}

public extension ParentCoordinator {
    func subcoordinator<T>(ofType coordinatorType: T.Type) -> T? where T: Coordinator {
        return subcoordinators.first { $0 is T } as? T
    }
}
