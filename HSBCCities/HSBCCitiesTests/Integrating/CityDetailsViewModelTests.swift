import Foundation
import XCTest

@testable import HSBCCities
class CityDetailsViewModelTests: XCTestCase {
    var dependencies: CityDetailsViewModel.Dependencies!
    var dataProvider: CityDetailsDataProviderProtocol!
    var favoritesManager: FavoriteManagerProtocol!
    var viewDelegate: CityDetailsViewDelegate!
    var cityViewModel: CityViewModel!

    override func setUp() {
        dataProvider = MockCityDetailsDataProvider(shouldSucceed: true, waitTime: 0.1)
        favoritesManager = MockFavoritesManager(favoriteObjects: [1,2,3,4,5])
        viewDelegate = MockCityDetailsViewDelegate()
        dependencies = MockCityDetailsDependencies(dataProvider: dataProvider, favoriteManager: favoritesManager)
        cityViewModel = MockResponses.cityViewModel()
    }

    override func tearDown() {
        dependencies = nil
        viewDelegate = nil
        favoritesManager = nil
        dataProvider = nil
        cityViewModel = nil
    }
    
    func testViewModelInitialState() {
        let viewModel = CityDetailsViewModel(dependencies: dependencies, cityViewModel: cityViewModel)
        XCTAssertTrue(viewModel.state == .idle)
    }
    
    func testViewModelSuccessStateChanging() {
        let viewModel = CityDetailsViewModel(dependencies: dependencies, cityViewModel: cityViewModel)
        let testViewDelegate = MockCityDetailsViewDelegate()
        
        XCTAssertTrue(viewModel.state == .idle)
        XCTAssertTrue(testViewDelegate.state == .idle)

        viewModel.didLoad(viewDelegate: testViewDelegate)
        XCTAssertTrue(viewModel.state == .loading)
        XCTAssertTrue(testViewDelegate.state == .loading)

        waitUntil {
            if case .presenting = testViewDelegate.state {
                return true
            }
            return false
        }
        if case .presenting = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
    }
    
    func testViewModelErrorStateChanging() {
        let errorDataProvider = MockCityDetailsDataProvider(shouldSucceed: false, waitTime: 0.1)
        let viewModel = CityDetailsViewModel(dependencies: MockCityDetailsDependencies(dataProvider: errorDataProvider, favoriteManager: favoritesManager), cityViewModel: cityViewModel)
        let testViewDelegate = MockCityDetailsViewDelegate()
        
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

        if case .failed = viewModel.state {
            XCTAssertTrue(true)
        } else {
            XCTFail()
        }
    }
    
    func testViewModelIntegrationWithFavoritesManager() {
        let viewModel = CityDetailsViewModel(dependencies: dependencies, cityViewModel: cityViewModel)
        let testViewDelegate = MockCityDetailsViewDelegate()
        
        viewModel.viewDelegate = testViewDelegate
        viewModel.toggleFavorite()
        
        XCTAssertTrue(testViewDelegate.isFavorite)
    }
}
