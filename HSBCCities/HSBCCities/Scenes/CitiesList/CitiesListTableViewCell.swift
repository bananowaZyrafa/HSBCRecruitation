import UIKit

class CitiesListCellViewModel {
    let ID: Int
    let imageURL: URL
    let title: String
    var image: UIImage? = nil
    var isFavorite: Bool {
        didSet { favoriteStateChanged?(isFavorite) }
    }
    let buttonSelected: ((Int) -> Void)
    var favoriteStateChanged: ((Bool) -> Void)?
    
    init(ID: Int, imageURL: URL, title: String, isFavorite: Bool, buttonSelectedClosure: @escaping ((Int) -> Void)) {
        self.ID = ID 
        self.imageURL = imageURL
        self.title = title
        self.isFavorite = isFavorite
        self.buttonSelected = buttonSelectedClosure
    }
}

final class CitiesListTableViewCell: UITableViewCell {
    static let cellID = "CitiesListTableViewCell"
    
    override var reuseIdentifier: String? {
        "CitiesListTableViewCell"
    }
    
    private lazy var containerView: UIView = {
        let view = UIView().forAutoLayout()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5.0
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var cityImageView: UIImageView = {
        let imageView = UIImageView().forAutoLayout()
        imageView.layer.cornerRadius = 5.0
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().forAutoLayout()
        label.textAlignment = .center
        label.layer.borderWidth = 0.5
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.cornerRadius = 5.0
        label.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton().forAutoLayout()
        button.setImage(.star, for: .normal)
        button.setImage(.starFilled, for: .selected)
        button.tintColor = .white 
        button.addTarget(self, action: #selector(selectFavoriteButton), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: CitiesListCellViewModel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        setupViews()
        selectionStyle = .none
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4.0),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 4.0),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0)
        ])

        containerView.addSubview(cityImageView)
        containerView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            cityImageView.heightAnchor.constraint(equalToConstant: 200.0),
            cityImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            cityImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0),
            cityImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0),
            titleLabel.heightAnchor.constraint(equalToConstant: 30.0),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0),
            titleLabel.topAnchor.constraint(equalTo: cityImageView.bottomAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10.0)
        ])
        
        containerView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: cityImageView.topAnchor, constant: 4.0),
            favoriteButton.trailingAnchor.constraint(equalTo: cityImageView.trailingAnchor, constant: -4.0)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cityImageView.image = nil
        cityImageView.cancelFetchingTask()
    }
    
    @objc private func selectFavoriteButton() {
        viewModel.buttonSelected(viewModel.ID)
    }
    
    func configure(with model: CitiesListCellViewModel) {
        self.viewModel = model
        model.favoriteStateChanged = { [weak self] isFavorite in
            self?.favoriteButton.isSelected = isFavorite
        }
        titleLabel.text = model.title
        favoriteButton.isSelected = model.isFavorite
        cityImageView.downloadFrom(url: model.imageURL) { [weak self] image in
            self?.viewModel.image = image 
        }
    }
    
    deinit {
        cityImageView.cancelFetchingTask()
    }
}
