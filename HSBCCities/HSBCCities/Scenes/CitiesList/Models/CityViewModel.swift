import UIKit

struct CityViewModel {
    let ID: Int
    let imageURL: URL
    let title: String
    var image: UIImage?
    var isFavorite: Bool
}

extension CityViewModel {
    init(cellModel: CitiesListCellViewModel, isFavorite: Bool) {
        self.ID = cellModel.ID
        self.imageURL = cellModel.imageURL
        self.title = cellModel.title
        self.image = cellModel.image
        self.isFavorite = isFavorite
    }
}
