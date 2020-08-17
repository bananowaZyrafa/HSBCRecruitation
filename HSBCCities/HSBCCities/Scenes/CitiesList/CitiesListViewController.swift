import UIKit

protocol CitiesListViewModelProtocol: UITableViewDelegate, UITableViewDataSource {
    func didLoad(viewDelegate: CitiesListViewDelegate)
    func toggleFavoritesFilter()
}

final class CitiesListViewController: UIViewController, StatePresenting {
    
    private let tableView = UITableView()
    lazy var toggleFavoriteBarButtonItem = {
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
    private let viewModel: CitiesListViewModelProtocol
    
    init(viewModel: CitiesListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTableView()
        setupNavigationBar()
        viewModel.didLoad(viewDelegate: self)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 250
        tableView.separatorStyle = .none
        tableView.register(CitiesListTableViewCell.self, forCellReuseIdentifier: CitiesListTableViewCell.cellID)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = toggleFavoriteBarButtonItem
        navigationItem.title = "Cities"
    }
    
    @objc private func toggleFavorite() {
        viewModel.toggleFavoritesFilter()
    }
}

extension CitiesListViewController: CitiesListViewDelegate {
    func render(state: CitiesListViewModel.State) {
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
        case .presentingFiltered:
            print("Presenting filtered")
            removeAnyChildViews()
            toggleFavoriteBarButtonItem.image = .starFilled
            toggleFavoriteBarButtonItem.isEnabled = true
            tableView.reloadData()
        case .presenting:
            print("Presenting list")
            removeAnyChildViews()
            toggleFavoriteBarButtonItem.image = .star
            toggleFavoriteBarButtonItem.isEnabled = true
            tableView.reloadData()
        }
    }
}
