import Foundation
@testable import HSBCCities

class MockFavoritesManager: FavoriteManagerProtocol {
    var favoriteObjects: [Int]
    
    init(favoriteObjects: [Int]) {
        self.favoriteObjects = favoriteObjects
    }
    
    var synchronizatioinDelegate: FavoriteManagerSynchronizingDelegate?
    
    func isFavorite(ID object: Int) -> Bool {
        favoriteObjects.contains(object)
    }
    
    @discardableResult
    func toggleFavorite(forID object: Int) -> Bool {
        if favoriteObjects.contains(object) {
            guard let index = favoriteObjects.firstIndex(of: object) else { return false }
            favoriteObjects.remove(at: index)
        } else {
            favoriteObjects.append(object)
        }
        let currentlyFavorite = isFavorite(ID: object)
        synchronizatioinDelegate?.favoriteStateChanged(forObjectWithID: object, isFavorite: currentlyFavorite)
        return currentlyFavorite
    }
    
    func retrieveFavoriteIDs() -> [Int] {
        favoriteObjects
    }
}
