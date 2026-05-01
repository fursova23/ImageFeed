import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet private var cellImage: UIImageView!
    @IBOutlet private var likeButton: UIButton!
    @IBOutlet private var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.kf.indicatorType = .none
    }
    
    func configure(imageURL: String?, date: String, isLiked: Bool, completion: (() -> Void)? = nil) {
        cellImage.kf.indicatorType = .activity
        cellImage.kf.setImage(
            with: URL(string: imageURL ?? ""),
            placeholder: UIImage(resource: .imageMock),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .cacheOriginalImage
            ]
        ) { result in
            if case .success = result {
                completion?()
            }
        }
        
        dateLabel.text = date
        likeButton.setImage(UIImage(resource: isLiked ? .active : .noActive),for: .normal)
    }
}
