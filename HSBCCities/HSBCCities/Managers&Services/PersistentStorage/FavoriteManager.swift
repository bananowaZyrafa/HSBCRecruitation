import Foundation

protocol FavoriteManagerProtocol {
    var synchronizatioinDelegate: FavoriteManagerSynchronizingDelegate? { get set }
    func isFavorite(ID object: Int) -> Bool
    @discardableResult func toggleFavorite(forID object: Int) -> Bool
    func retrieveFavoriteIDs() -> [Int]
}

protocol FavoriteManagerSynchronizingDelegate: class {
    func favoriteStateChanged(forObjectWithID ID: Int, isFavorite: Bool)
}

final class FavoriteManager: FavoriteManagerProtocol {
    private enum Constants {
        static let savedIDsKey = "FavoritesCityIDs"
    }
    let userDefaults: UserDefaults
    
    weak var synchronizatioinDelegate: FavoriteManagerSynchronizingDelegate?
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func retrieveFavoriteIDs() -> [Int] {
        guard let array = userDefaults.array(forKey: Constants.savedIDsKey) as? [Int] else { return [Int]() }
        return array
    }
    
    func saveFavorite(IDs array: [Int]?) {
        userDefaults.set(array, forKey: Constants.savedIDsKey)
    }
    
    func saveFavorite(ID object: Int) {
        var array = retrieveFavoriteIDs()
        array.append(object)
        saveFavorite(IDs: array)
    }

    func removeFavorite(ID object: Int) {
        var array = retrieveFavoriteIDs()
        array = array.filter { $0 != object }
        saveFavorite(IDs: array)
    }
    
    func removeAllFavorites() {
        saveFavorite(IDs: nil)
    }
    
    func isFavorite(ID object: Int) -> Bool {
        let array = retrieveFavoriteIDs()
        return array.contains(object)
    }
    
    @discardableResult
    func toggleFavorite(forID object: Int) -> Bool {
        if isFavorite(ID: object) {
            removeFavorite(ID: object)
        } else {
            saveFavorite(ID: object)
        }
        let currentlyFavorite = isFavorite(ID: object)
        synchronizatioinDelegate?.favoriteStateChanged(forObjectWithID: object, isFavorite: currentlyFavorite)
        return currentlyFavorite
    }
}
