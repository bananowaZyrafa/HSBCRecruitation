import Foundation

protocol CityDetailsViewDelegate: class {
    func render(state: CityDetailsViewModel.State)
    func updateFavoriteState(isFavorite: Bool)
}

protocol CityDetailsCoordinatorDelegate: class {
    func navigateToDetails(ofVisitors visitors: [Visitor])
}

final class CityDetailsViewModel: CityDetailsViewModelProtocol {
    
    typealias Dependencies = HasCityDetailsDataProvider & HasFavoriteManager
    
    enum State {
        case idle
        case loading
        case presenting(CityDetailsPresentableModel)
        case failed(ErrorViewModel)
    }
    
    let cityViewModel: CityViewModel
    
    private let dependencies: Dependencies
    private var presentableModel: CityDetailsPresentableModel?
    private(set) var state: State = .idle {
        didSet { viewDelegate?.render(state: state) }
    }
    
    weak var viewDelegate: CityDetailsViewDelegate?
    weak var coordinator: CityDetailsCoordinatorDelegate?
    
    init(dependencies: Dependencies, cityViewModel: CityViewModel) {
        self.dependencies = dependencies
        self.cityViewModel = cityViewModel
    }
    
    private func loadCityDetails() {
        state = .loading
        dependencies
            .cityDetailsDataProvider
            .fetchCityDetails(for: cityViewModel.city, queue: .main) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .failure(let error):
                    self.state = .failed(self.createErrorViewModel(from: error))
                case .success(let cityDetails):
                    let presentableModel = CityDetailsPresentableModel(cityDetails: cityDetails, cityViewModel: self.cityViewModel)
                    self.presentableModel = presentableModel
                    self.state = .presenting(presentableModel)
                }
        }
    }
    
    private func createErrorViewModel(from error: Error) -> ErrorViewModel {
        ErrorViewModel(error: error) { [weak self] in
            self?.loadCityDetails()
        }
    }
    
    func didLoad(viewDelegate: CityDetailsViewDelegate) {
        self.viewDelegate = viewDelegate
        loadCityDetails()
    }
    
    func toggleFavorite() {
        let isFavorite = dependencies.favoriteManager.toggleFavorite(forID: cityViewModel.ID)
        viewDelegate?.updateFavoriteState(isFavorite: isFavorite)
    }
    
    func presentVisitors() {
        guard let model = presentableModel else { return }
        coordinator?.navigateToDetails(ofVisitors: model.visitors)
    }
}

private extension CityViewModel {
    var city: City {
        City(ID: ID, name: title, thumbnailURL: imageURL)
    }
}
