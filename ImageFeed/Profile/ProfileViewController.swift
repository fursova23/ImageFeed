import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var imageView: UIImageView = UIImageView(image: UIImage(resource: .photo))
    private lazy var nameLabel: UILabel = UILabel()
    private lazy var tagLabel: UILabel = UILabel()
    private lazy var statusLabel: UILabel = UILabel()
    
    private final let profileService = ProfileService.shared
    private final let profileImageService = ProfileImageService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
// "Старое" API NotificationCenter
//    override init(nibName: String?, bundle: Bundle?) {
//        super.init(nibName: nibName, bundle: bundle)
//        addObserver()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        addObserver()
//    }
//    
//    deinit {
//        removeObserver()
//    }
//    
//    private func addObserver() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(updateAvatar(notification:)),
//            name: ProfileImageService.didChangeNotification,
//            object: nil
//        )
//    }
//    
//    private func removeObserver() {
//        NotificationCenter.default.removeObserver(
//            self,
//            name: ProfileImageService.didChangeNotification,
//            object: nil
//        )
//    }
//    
//    @objc
//    private func updateAvatar(notification: Notification) {
//        guard
//            isViewLoaded,
//            let userInfo = notification.userInfo,
//            let profileImageURL = userInfo["URL"] as? String,
//            let url = URL(string: profileImageURL)
//        else { return }
//        
//        // TODO Kingfisher
//    }
    
    private func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let url = URL(string: profileImageURL)
        else { return }
        // TODO Обновить аватар, используя Kingfisher
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupNameLabel()
        setupTagLabel()
        setupStatusLabel()
        setupButton()
        
//        if let avatarURL = profileImageService.avatarURL,
//           let url = URL(string: avatarURL) {
//            // TODO
//        }
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) {
            [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
        updateAvatar()
        
        if let profile = profileService.profile {
            updateProfileDetails(profile: profile)
        }
    }
    
    private func updateProfileDetails(profile: Profile) {
        nameLabel.text = profile.name.isEmpty
        ? "Имя не указано"
        : profile.name
        tagLabel.text = profile.loginName.isEmpty
        ? "@неизвестный_пользователь"
        : profile.loginName
        statusLabel.text = (profile.bio?.isEmpty ?? true)
        ? "Профиль не заполнен"
        : profile.bio
    }
    
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
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 99),
            button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
        
    }
    
    @objc
    private func didTapButton() {
        nameLabel.removeFromSuperview()
        tagLabel.removeFromSuperview()
        statusLabel.removeFromSuperview()
        imageView.image = UIImage(named: "Stub")
    }
    
}
