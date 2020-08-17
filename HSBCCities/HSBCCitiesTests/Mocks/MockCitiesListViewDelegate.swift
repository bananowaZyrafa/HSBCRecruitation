import Foundation

@testable import HSBCCities
class MockCitiesListViewDelegate: CitiesListViewDelegate {
    private(set) var state: CitiesListViewModel.State = .idle
    
    func render(state: CitiesListViewModel.State) {
        self.state = state
    }
}
