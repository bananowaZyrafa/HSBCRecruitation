import Foundation

@testable import HSBCCities
class MockCityDetailsViewDelegate: CityDetailsViewDelegate {
    
    private(set) var state: CityDetailsViewModel.State = .idle
    private(set) var isFavorite: Bool = false
    
    func render(state: CityDetailsViewModel.State) {
        self.state = state
    }
    
    func updateFavoriteState(isFavorite: Bool) {
        self.isFavorite = isFavorite
    }
}
