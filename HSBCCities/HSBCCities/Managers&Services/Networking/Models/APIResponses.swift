import Foundation

struct CitiesListAPIResponse: Decodable {
    let cities: [City]
}

struct CityVisitorsAPIResponse: Decodable {
    let visitors: [Visitor]
}

struct CityRatingAPIResponse: Decodable {
    let rating: Rating
}
