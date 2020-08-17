import XCTest
@testable import HSBCCities

class FavoritesManagerTests: XCTestCase {
    var favoritesManager: FavoriteManager!
    
    override func setUp() {
        favoritesManager = FavoriteManager(userDefaults: UserDefaults())
    }

    override func tearDown() {
        favoritesManager = nil
    }
    
    func testSavingObject() {
        favoritesManager.saveFavorite(ID: 1)
        let savedIDs = favoritesManager.retrieveFavoriteIDs()
        XCTAssert(savedIDs.contains(1))
    }
    
    func testRemovingObject() {
        favoritesManager.saveFavorite(ID: 1)
        favoritesManager.removeFavorite(ID: 1)
        let savedIDs = favoritesManager.retrieveFavoriteIDs()
        XCTAssert(!savedIDs.contains(1))
    }
    
    func testEmptyFavorites() {
        favoritesManager.removeAllFavorites()
        let favoritesObjects = favoritesManager.retrieveFavoriteIDs()
        XCTAssert(favoritesObjects.isEmpty)
    }
    
    func testFavorites() {
        favoritesManager.removeAllFavorites()
        
        var favoritesObjects = favoritesManager.retrieveFavoriteIDs()
        XCTAssert(favoritesObjects.isEmpty)
        
        favoritesManager.saveFavorite(IDs: [1,2,3,4,5])
        favoritesObjects = favoritesManager.retrieveFavoriteIDs()
        XCTAssert(favoritesObjects.count == 5)
    }
}
