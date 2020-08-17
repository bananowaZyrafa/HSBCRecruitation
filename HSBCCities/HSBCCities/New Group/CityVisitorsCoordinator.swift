import UIKit
import Coordinators

final class CityVisitorsCoordinator: BaseCoordinator {
    init(presentationStyle: CoordinatorPresentationStyle = .modal, visitors: [Visitor]) {
        let viewModel = CityVisitorsViewModel(visitors: visitors)
        let viewController = CityVisitorsViewController(viewModel: viewModel)
        super.init(viewController: viewController, presentationStyle: presentationStyle)
        viewModel.coordinator = self
    }
}

extension CityVisitorsCoordinator: CityVisitorsCoordinatorProtocol {
    func close() {
        dismiss()
    }
}
