import UIKit

final class LoadingView: UIView {
    private lazy var containerView: UIView = {
        let view = UIView().forAutoLayout()
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        return view
    }()
    private lazy var activityIndicator = UIActivityIndicatorView(style: .gray).forAutoLayout()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10.0
        addSubview(containerView)
        containerView.pinToSuperview()
        containerView.addSubview(activityIndicator.forAutoLayout())
        activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
    }
    
    func startAnimating() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimating() {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
}
