import UIKit

final class ProfileViewController: UIViewController {
    
    private lazy var imageView: UIImageView = UIImageView(image: UIImage(resource: .photo))
    private lazy var nameLabel: UILabel = UILabel()
    private lazy var tagLabel: UILabel = UILabel()
    private lazy var statusLabel: UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImageView()
        setupNameLabel()
        setupTagLabel()
        setupStatusLabel()
        setupButton()
    }
    
    private func setupImageView() {
        imageView.tintColor = .gray
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
        
        button.tintColor = .red
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
