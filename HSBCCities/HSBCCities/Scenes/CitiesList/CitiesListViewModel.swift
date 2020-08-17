import UIKit

protocol CitiesListViewDelegate: class {
    func render(state: CitiesListViewModel.State)
}

protocol CitiesListCoordinatorDelegate: class {
    func navigateToDetails(ofCity cityViewModel: CityViewModel)
}

final class CitiesListViewModel: NSObject, CitiesListViewModelProtocol {
    typealias Dependencies = HasCitiesListNetworkProvider & HasFavoriteManager
    
    private let dependencies: Dependencies
    
    enum State {
        case idle
        case loading
        case presenting
        case presentingFiltered
        case failed(ErrorViewModel)
    }
    
    private(set) var state: State = .idle {
        didSet { viewDelegate?.render(state: state) }
    }
    
    weak var viewDelegate: CitiesListViewDelegate?
    weak var coordinator: CitiesListCoordinatorDelegate?
    
    private(set) var models = [City]() {
        didSet { transformModelsIntoCellModels() }
    }
    private(set) var favoritesIDs = [Int]()
    private var cellModels = [CitiesListCellViewModel]() {
        didSet { favoriteCellModels = cellModels.filter { $0.isFavorite } }
    }
    private var favoriteCellModels: [CitiesListCellViewModel] = []
    private var anyCellModels: [CitiesListCellViewModel] {
        showOnlyFavorites ? favoriteCellModels : cellModels
    }
    private var showOnlyFavorites: Bool = false
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        super.init()
    }
    
    func didLoad(viewDelegate: CitiesListViewDelegate) {
        self.viewDelegate = viewDelegate
        loadCitiesList()
    }
    
    func toggleFavoritesFilter() {
        showOnlyFavorites.toggle()
        state = showOnlyFavorites ? .presentingFiltered : .presenting
    }
    
    func toggleFavoriteFor(ID: Int)  {
        dependencies.favoriteManager.toggleFavorite(forID: ID)
    }
    
    func updateFavorites() {
        favoritesIDs = dependencies.favoriteManager.retrieveFavoriteIDs()
    }
    
    private func loadCitiesList() {
        state = .loading
        dependencies.citiesListSessionProvider.fetchCityList { [weak self] (response) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch response {
                case .failure(let error):
                    self.state = .failed(self.createErrorViewModel(from: error))
                case .success(let cityList):
                    self.models = cityList
                    self.state = .presenting
                }
            }
        }
    }
    
    private func transformModelsIntoCellModels() {
        let newCellModels = models.map {
            CitiesListCellViewModel(ID: $0.ID,
                                    imageURL: $0.thumbnailURL,
                                    title: $0.name,
                                    isFavorite: isFavorite(ID: $0.ID)) { [weak self] ID in
                self?.toggleFavoriteFor(ID: ID)
            }
        }
        cellModels = newCellModels
    }
    
    private func createErrorViewModel(from error: Error) -> ErrorViewModel {
        ErrorViewModel(error: error) { [weak self] in
            self?.loadCitiesList()
        }
    }
    
    private func updateCellModelFavoriteState(at index: Int, isFavorite: Bool) {
        let newModel = cellModels[index]
        newModel.isFavorite = isFavorite
        cellModels[index] = newModel
    }
    
    private func isFavorite(ID: Int) -> Bool {
        dependencies.favoriteManager.isFavorite(ID: ID)
    }
    
    private func cellModel(at indexPath: IndexPath) -> CitiesListCellViewModel {
        let models = showOnlyFavorites ? favoriteCellModels : cellModels
        return models[indexPath.row]
    }
}

extension CitiesListViewModel: FavoriteManagerSynchronizingDelegate {
    func favoriteStateChanged(forObjectWithID ID: Int, isFavorite: Bool) {
        updateFavorites()
        guard let row = cellModels.firstIndex(where: { $0.ID == ID }) else { return }
        updateCellModelFavoriteState(at: row, isFavorite: isFavorite)
    }
}

extension CitiesListViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = anyCellModels[indexPath.row]
        let cityViewModel = CityViewModel(cellModel: cellModel, isFavorite: dependencies.favoriteManager.isFavorite(ID: cellModel.ID))
        coordinator?.navigateToDetails(ofCity: cityViewModel)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        anyCellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CitiesListTableViewCell.cellID, for: indexPath) as? CitiesListTableViewCell else {
            return UITableViewCell()
        }
        
        let model = cellModel(at: indexPath)
        
        cell.configure(with: model)
        return cell
    }
}
