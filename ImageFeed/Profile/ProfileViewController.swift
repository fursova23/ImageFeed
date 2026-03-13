import UIKit

final class ProfileViewController: UIViewController {
    
    private var imageView: UIImageView = UIImageView(image: UIImage(named: "Photo"))
    private var nameLabel: UILabel = UILabel()
    private var tagLabel: UILabel = UILabel()
    private var statusLabel: UILabel = UILabel()
    
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
        
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
    }
    
    private func setupNameLabel() {
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupTagLabel() {
        tagLabel.text = "@ekaterina_nov"
        tagLabel.textColor = .gray
        tagLabel.font = UIFont.systemFont(ofSize: 13)
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tagLabel)
        
        tagLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        tagLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        tagLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupStatusLabel() {
        statusLabel.text = "Hello, world!"
        statusLabel.textColor = .white
        statusLabel.font = UIFont.systemFont(ofSize: 13)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusLabel)
        
        statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        statusLabel.topAnchor.constraint(equalTo: tagLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    private func setupButton() {
        let button = UIButton.systemButton(
            with: UIImage(systemName: "ipad.and.arrow.forward")!,
            target: self,
            action: #selector(Self.didTapButton)
        )
        
        button.tintColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: 44).isActive = true
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        button.topAnchor.constraint(equalTo: view.topAnchor, constant: 99).isActive = true
        button.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
    }
    
    @objc
    private func didTapButton() {
        nameLabel.removeFromSuperview()
        tagLabel.removeFromSuperview()
        statusLabel.removeFromSuperview()
        imageView.image = UIImage(named: "Stub")
    }
    
}
