import UIKit

extension UIImage {
    static let star = UIImage(named: "star3")?.scaleTo(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
    static let starFilled = UIImage(named: "star3-filled")?.scaleTo(CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
}

extension UIImage {
    func scaleTo(_ newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
