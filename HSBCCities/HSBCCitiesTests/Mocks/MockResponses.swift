import Foundation
@testable import HSBCCities

final class MockResponses {
    static let cities: [City] = [
        City(ID: 11, name: "Kraków", thumbnailURL: URL(string: "www.google.com")!),
        City(ID: 12, name: "Poznań", thumbnailURL: URL(string: "www.google.com")!),
        City(ID: 11, name: "Toruń", thumbnailURL: URL(string: "www.google.com")!),
        City(ID: 11, name: "Wrocław", thumbnailURL: URL(string: "www.google.com")!),
        City(ID: 11, name: "Białystok", thumbnailURL: URL(string: "www.google.com")!)
    ]
    
    static let visitors: [Visitor] = [
        Visitor(name: "Bartosz"),
        Visitor(name: "Marcin"),
        Visitor(name: "Michał"),
        Visitor(name: "Klaudia"),
        Visitor(name: "Maciej"),
        Visitor(name: "Ewelina")
    ]
    
    static let rating: Rating = Rating(avgRating: 2.0, maxRating: 10.0)
    
    static let city: City = City(ID: 100, name: "Washington", thumbnailURL: URL(string: "www.google.com")!)
    
    static let cityDetails: CityDetails = CityDetails(visitors: MockResponses.visitors, rating: MockResponses.rating, city: MockResponses.city)
    
    static func cityViewModel(isFavorite: Bool = true) -> CityViewModel {
        CityViewModel(ID: MockResponses.city.ID, imageURL: MockResponses.city.thumbnailURL, title: MockResponses.city.name, image: nil, isFavorite: isFavorite)
    }
}
