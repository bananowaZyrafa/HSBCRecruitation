import Foundation
import XCTest

@testable import HSBCCities

final class MockCitiesListDependencies: HasCitiesListNetworkProvider & HasFavoriteManager {
    var citiesListSessionProvider: CitiesListNetworkProviderProtocol
    var favoriteManager: FavoriteManagerProtocol
    
    init(networkProvider: CitiesListNetworkProviderProtocol, favoriteManager: FavoriteManagerProtocol) {
        self.citiesListSessionProvider = networkProvider
        self.favoriteManager = favoriteManager
    }
}

final class MockCityDetailsDependencies: HasCityDetailsDataProvider & HasFavoriteManager {
    var cityDetailsDataProvider: CityDetailsDataProviderProtocol
    var favoriteManager: FavoriteManagerProtocol
    
    init(dataProvider: CityDetailsDataProviderProtocol,
         favoriteManager: FavoriteManagerProtocol) {
        self.cityDetailsDataProvider = dataProvider
        self.favoriteManager = favoriteManager
    }
}
