import UIKit

protocol StatePresenting: class {
    var activityIndicator: LoadingView { get }
    var errorViewController: ErrorViewController? { get set }
    
    func presentLoadingIndicator()
    func removeAnyChildViews()
    func presentErrorVC(withViewModel viewModel: ErrorViewModel)
    func presentLoading()
}

extension StatePresenting where Self: UIViewController {
    func presentLoadingIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func removeAnyChildViews() {
        activityIndicator.stopAnimating()
        errorViewController = nil
    }
    
    func presentErrorVC(withViewModel viewModel: ErrorViewModel) {
        removeAnyChildViews()
        errorViewController = ErrorViewController(errorViewModel: viewModel)
    }
    
    func presentLoading() {
        removeAnyChildViews()
        activityIndicator.startAnimating()
    }
}
