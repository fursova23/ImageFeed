import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImagesListDelegate?
    
    @IBOutlet weak private var cellImage: UIImageView!
    @IBOutlet weak private var likeButton: UIButton!
    @IBOutlet weak private var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.kf.indicatorType = .none
    }
    
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func configure(imageURL: String?, date: String, isLiked: Bool) {
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: URL(string: imageURL ?? ""),
            placeholder: UIImage(resource: .imageMock),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        ) { [weak self] result in
            guard let self else { return }
            if case .success = result {
                self.delegate?.imageListCellDidFinishLoading(self)
            }
        }
        
        dateLabel.text = date
        setIsLiked(isLiked)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        likeButton.setImage(UIImage(resource: isLiked ? .active : .noActive), for: .normal)
    }
}
