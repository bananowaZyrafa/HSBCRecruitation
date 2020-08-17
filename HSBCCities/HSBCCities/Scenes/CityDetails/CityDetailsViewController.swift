import UIKit

protocol CityDetailsViewModelProtocol {
    var cityViewModel: CityViewModel { get }
    func didLoad(viewDelegate: CityDetailsViewDelegate)
    func toggleFavorite()
    func presentVisitors()
}

final class CityDetailsViewController: UIViewController, StatePresenting {
    private let viewModel: CityDetailsViewModelProtocol
    
    private var navigationBarHeight: CGFloat {
        navigationController?.navigationBar.frame.height ?? 44.0
    }
    
    private lazy var toggleFavoriteBarButtonItem = {
        UIBarButtonItem(image: .star, style: UIBarButtonItem.Style.plain, target: self, action: #selector(toggleFavorite))
    }()
    
    lazy var activityIndicator: LoadingView = {
        let view = LoadingView().forAutoLayout()
        view.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        return view
    }()
    
    var errorViewController: ErrorViewController? {
        didSet {
            guard errorViewController != oldValue else { return }
            oldValue?.remove()
            if let errorViewController = errorViewController {
                add(errorViewController)
                errorViewController.view.translatesAutoresizingMaskIntoConstraints = false
                errorViewController.view.pinToSuperview()
            }
        }
    }
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView().forAutoLayout()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView().forAutoLayout()
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().forAutoLayout()
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        return label
    }()
    
    private lazy var visitorsButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(visitorsButtonTapped), for: .touchUpInside)
        button.setTitle("Placeholder title", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var avgRatingLabel: UILabel = {
        let label = UILabel()
        label.text = "Placeholder label"
        label.textAlignment = .center
        label.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        return label
    }()
    
    init(viewModel: CityDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure(withCityViewModel: viewModel.cityViewModel)
        setUpViews()
        presentLoadingIndicator()
        viewModel.didLoad(viewDelegate: self)
    }
    
    private func configure(withCityViewModel cityViewModel: CityViewModel) {
        if let image = cityViewModel.image {
            imageView.image = image
        } else {
            imageView.downloadFrom(url: cityViewModel.imageURL)
        }
        titleLabel.text = cityViewModel.title
        toggleFavoriteBarButtonItem.image = cityViewModel.isFavorite ? .starFilled : .star
    }
    
    private func configure(withPresentablleModel presentableModel: CityDetailsPresentableModel) {
        visitorsButton.setTitle(presentableModel.visitorsText, for: .normal)
        avgRatingLabel.text = presentableModel.avgRatingText
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = toggleFavoriteBarButtonItem
        navigationItem.title = "City Details"
    }
    
    private func setUpViews() {
        setupNavigationBar()
        view.addSubview(stackView)
        stackView.pin(to: .init(top: navigationBarHeight + 64.0, left: 8.0, bottom: 64.0, right: 8.0))
        [imageView, titleLabel, visitorsButton, avgRatingLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    @objc private func visitorsButtonTapped() {
        viewModel.presentVisitors()
    }
    
    @objc private func toggleFavorite() {
        viewModel.toggleFavorite()
    }
}

extension CityDetailsViewController: CityDetailsViewDelegate {
    func updateFavoriteState(isFavorite: Bool) {
        let starImage: UIImage? = isFavorite ? .starFilled : .star
        toggleFavoriteBarButtonItem.image = starImage
    }
    
    func render(state: CityDetailsViewModel.State) {
        switch state {
        case .failed(let errorViewModel):
            toggleFavoriteBarButtonItem.isEnabled = false
            presentErrorVC(withViewModel: errorViewModel)
        case .idle:
            toggleFavoriteBarButtonItem.isEnabled = true
            removeAnyChildViews()
        case .loading:
            presentLoadingIndicator()
            toggleFavoriteBarButtonItem.isEnabled = false
        case .presenting(let presentableModel):
            removeAnyChildViews()
            toggleFavoriteBarButtonItem.isEnabled = true
            configure(withPresentablleModel: presentableModel)
        }
    }
}
