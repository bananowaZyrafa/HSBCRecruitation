import UIKit

final class CityVisitorsViewController: UIViewController {
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView.forAutoLayout()
    }()
    
    private lazy var closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(closeButtonTapped))
    
    private let viewModel: CityVisitorsViewModelProtocol
    
    init(viewModel: CityVisitorsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Visitors"
        view.backgroundColor = .white
        setupViews()
    }
    
    private func setupViews() {
        navigationItem.rightBarButtonItem = closeBarButtonItem
        view.addSubview(stackView)
        stackView.pin(to: .init(top: 64.0, left: 8.0, bottom: 64.0, right: 8.0))
        let labels = stringsToLabels(strings: viewModel.visitorsNames)
        labels.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func stringsToLabels(strings: [String]) -> [UILabel] {
        return strings.map {
            let label = UILabel()
            label.textAlignment = .center
            label.text = $0
            return label
        }
    }
    
    @objc private func closeButtonTapped() {
        viewModel.close()
    }
}

