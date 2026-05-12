import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: ProfilePresenterProtocol!
    
    private lazy var imageView: UIImageView = UIImageView()
    private lazy var nameLabel: UILabel = UILabel()
    private lazy var tagLabel: UILabel = UILabel()
    private lazy var statusLabel: UILabel = UILabel()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypBlackIOS
        
        setupImageView()
        setupNameLabel()
        setupTagLabel()
        setupStatusLabel()
        setupButton()
        
        presenter?.viewDidLoad()
    }
    
    func configure(_ presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
        self.presenter.view = self
    }
    
    // MARK: - Private Methods
    
    private func setupImageView() {
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupTagLabel() {
        tagLabel.text = "@ekaterina_nov"
        tagLabel.textColor = .gray
        tagLabel.font = UIFont.systemFont(ofSize: 13)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagLabel)
        
        NSLayoutConstraint.activate([
            tagLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupStatusLabel() {
        statusLabel.text = "Hello, world!"
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 13)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupButton() {
        let button = UIButton.systemButton(
            with: UIImage(systemName: ProfileViewConstants.exitIcon) ?? UIImage(),
            target: self,
            action: #selector(Self.didTapButton)
        )
        
        button.tintColor = .ypRedIOS
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "logout button"
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 99),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func didTapButton() {
        showLogoutAlert()
    }
}

// MARK: - ProfileViewControllerProtocol

extension ProfileViewController: ProfileViewControllerProtocol {
    func updateAvatar(imageURL: URL) {
        let placeholderImage = UIImage(systemName: "person.circle.fill")?
            .withTintColor(.lightGray, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage
                .SymbolConfiguration(pointSize: 70, weight: .regular, scale: .large))
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: imageURL,
            placeholder: placeholderImage,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage,
                .forceRefresh
            ]
        )
    }
    
    func updateProfileDetails(name: String, login: String, bio: String?) {
        nameLabel.text = name
        tagLabel.text = login
        statusLabel.text = bio
    }
}

extension ProfileViewController {
    func showLogoutAlert() {
        let alert = UIAlertController(
            title: "Пока, пока!",
            message: "Уверены, что хотите выйти?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel))
        alert.addAction(UIAlertAction(title: "Да", style: .destructive) { [weak self] _ in
            self?.presenter?.didTapLogout()
        })
        present(alert, animated: true)
    }
}
