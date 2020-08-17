import Foundation
import XCTest

@testable import HSBCCities
class CitiesListViewModelTests: XCTestCase {
    var dependencies: (CitiesListViewModel.Dependencies)!
    var networkProvider: CitiesListNetworkProviderProtocol = MockCitiesListNetworkProvider(shouldSucceed: true, successResponse: MockResponses.cities, waitTime: 0.0)
    var cityDetailsNetworkProvider: CityDetailsNetworkProviderProtocol = MockCityDetailsNetworkProvider.instance
    var favoritesManager: FavoriteManagerProtocol = MockFavoritesManager(favoriteObjects: [1,2,3,4,5])
    var viewDelegate: CitiesListViewDelegate = MockCitiesListViewDelegate()
    
    override func setUp() {
        dependencies = MockCitiesListDependencies(networkProvider: networkProvider, favoriteManager: favoritesManager)
    }

    override func tearDown() {
        dependencies = nil
    }
    
    func testViewModelInitialState() {
        let viewModel = CitiesListViewModel(dependencies: dependencies)
        XCTAssertTrue(viewModel.state == .idle)
    }
    
    func testViewModelSuccessStateChanging() {
        let viewModel = CitiesListViewModel(dependencies: dependencies)
        let testViewDelegate = MockCitiesListViewDelegate()
        
        XCTAssertTrue(viewModel.state == .idle)
        XCTAssertTrue(testViewDelegate.state == .idle)
        
        
        viewModel.didLoad(viewDelegate: testViewDelegate)
        XCTAssertTrue(viewModel.state == .loading)
        XCTAssertTrue(testViewDelegate.state == .loading)
        
        waitUntil { testViewDelegate.state == .presenting }
        XCTAssertTrue(viewModel.models.count > 0)
        XCTAssertTrue(viewModel.state == .presenting)
    }
    
    func testViewModelErrorStateChanging() {
        let errorNetworkProvider = MockCitiesListNetworkProvider(shouldSucceed: false, successResponse: [], waitTime: 0.1)
        let viewModel = CitiesListViewModel(dependencies: MockCitiesListDependencies(networkProvider: errorNetworkProvider,
                                                                           favoriteManager: favoritesManager))
        let testViewDelegate = MockCitiesListViewDelegate()
        
        XCTAssertTrue(viewModel.state == .idle)
        XCTAssertTrue(testViewDelegate.state == .idle)

        viewModel.didLoad(viewDelegate: testViewDelegate)
        XCTAssertTrue(viewModel.state == .loading)
        XCTAssertTrue(testViewDelegate.state == .loading)

        waitUntil {
            if case .failed = testViewDelegate.state {
                return true
            }
            return false
        }
        XCTAssertTrue(viewModel.models.count == 0)
        if case .failed = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
    }
    
    func testVieModelFilteredState() {
        let viewModel = CitiesListViewModel(dependencies: dependencies)
        let testViewDelegate = MockCitiesListViewDelegate()
        viewModel.viewDelegate = testViewDelegate
        viewModel.toggleFavoritesFilter()
        XCTAssertTrue(viewModel.state == .presentingFiltered)
        XCTAssertTrue(testViewDelegate.state == .presentingFiltered)
    }
    
    func testViewModelInitialIntegrationWithFavoritesManager() {
        let viewModel = CitiesListViewModel(dependencies: dependencies)
        viewModel.updateFavorites()
        XCTAssertTrue(viewModel.favoritesIDs.count == 5)
    }
    
    func testViewModelIntegrationWithFavoritesManager() {
        let viewModel = CitiesListViewModel(dependencies: dependencies)
        favoritesManager.synchronizatioinDelegate = viewModel
        let objectID = 99
        
        XCTAssertFalse(favoritesManager.isFavorite(ID: objectID))
        
        viewModel.toggleFavoriteFor(ID: 99)
        XCTAssertTrue(favoritesManager.isFavorite(ID: objectID))
        XCTAssertTrue(viewModel.favoritesIDs.contains(99))
        
        viewModel.toggleFavoriteFor(ID: 99)
        XCTAssertFalse(favoritesManager.isFavorite(ID: objectID))
        XCTAssertFalse(viewModel.favoritesIDs.contains(99))
    }
}
