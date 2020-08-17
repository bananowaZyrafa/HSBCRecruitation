import UIKit

extension UIImageView {
    
    private static var fetchingTaskKey = "ImageFetchingTask.AssociatedKey"
    
    private var fetchingTask: URLSessionDataTask? {
        get {
            return objc_getAssociatedObject(self, &UIImageView.fetchingTaskKey) as? URLSessionDataTask
        }
        set {
            objc_setAssociatedObject(self, &UIImageView.fetchingTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func downloadFrom(url: URL, completion: ((UIImage?) -> Void)? = nil) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { () -> Void in
                self.image = image
                completion?(image)
            }
        }
        fetchingTask = dataTask
        dataTask.resume()
    }
    
    func cancelFetchingTask() {
        fetchingTask?.cancel()
    }
}
