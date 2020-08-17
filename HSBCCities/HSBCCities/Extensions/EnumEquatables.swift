import Foundation

extension CitiesListViewModel.State: Equatable {
    static func == (lhs: CitiesListViewModel.State, rhs: CitiesListViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.presenting, .presenting):
            return true
        case (.presentingFiltered, .presentingFiltered):
            return true
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}

extension CityDetailsViewModel.State: Equatable {
    static func == (lhs: CityDetailsViewModel.State, rhs: CityDetailsViewModel.State) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
        case (.loading, .loading):
            return true
        case (.presenting, .presenting):
            return true
        case (.failed, .failed):
            return true
        default:
            return false
        }
    }
}
