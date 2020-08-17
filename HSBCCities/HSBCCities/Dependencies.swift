import Foundation
import Networking

typealias AllNetworkProviders = ProviderProtocol & CitiesListNetworkProviderProtocol & CityDetailsNetworkProviderProtocol
typealias HasAllNetworkProviders = HasSessionProvider & HasCitiesListNetworkProvider & HasCityDetailsNetworkProvider

class Dependencies: HasAllNetworkProviders & HasFavoriteManager & HasCityDetailsDataProvider {
    lazy var sessionProvider: AllNetworkProviders = URLSessionProvider()
    lazy var favoriteManager: FavoriteManagerProtocol = FavoriteManager()
    lazy var cityDetailsDataProvider: CityDetailsDataProviderProtocol = CityDetailsDataProvider(dependencies: cityDetailsSessionProvider)
    
    var cityDetailsSessionProvider: CityDetailsNetworkProviderProtocol {
        sessionProvider
    }
    
    var citiesListSessionProvider: CitiesListNetworkProviderProtocol {
        sessionProvider
    }
}

protocol HasSessionProvider {
    var sessionProvider: AllNetworkProviders { get }
}

protocol HasFavoriteManager {
    var favoriteManager: FavoriteManagerProtocol { get set }
}

protocol HasCitiesListNetworkProvider {
    var citiesListSessionProvider: CitiesListNetworkProviderProtocol { get }
}

protocol HasCityDetailsNetworkProvider {
    var cityDetailsSessionProvider: CityDetailsNetworkProviderProtocol { get }
}

protocol HasCityDetailsDataProvider {
    var cityDetailsDataProvider: CityDetailsDataProviderProtocol { get }
}
