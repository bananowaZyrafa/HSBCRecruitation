import UIKit

struct CityDetailsPresentableModel {
    let cityViewModel: CityViewModel
    let visitors: [Visitor]
    let avgRating: Rating
    
    var visitorsText: String {
        "\(visitors.count) people visited this city"
    }
    
    var avgRatingText: String {
        "Average rating equals \(avgRating.avgRating) out of \(avgRating.maxRating)"
    }
}

extension CityDetailsPresentableModel {
    init(cityDetails: CityDetails, cityViewModel: CityViewModel) {
        self.cityViewModel = cityViewModel
        self.visitors = cityDetails.visitors
        self.avgRating = cityDetails.rating
    }
}
