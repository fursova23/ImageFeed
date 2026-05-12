import UIKit

final class ImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    private(set) var photos: [Photo] = []
    
    var photosCount: Int {
        photos.count
    }
    
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func photo(at IndexPath: IndexPath) -> Photo {
        photos[IndexPath.row]
    }
    
    func viewDidLoad() {
        subscribeToNotifications()
        imagesListService.fetchPhotosNextPage()
    }
    
    func didScrollToLastCell() {
        imagesListService.fetchPhotosNextPage()
    }
    
    func didTapLike(at indexPath: IndexPath, cell: ImagesListCell) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                view?.reloadRow(at: indexPath)
            case .failure(let error):
                print("[ImagesListPresenter.didTapLike]: Не удалось поменять статус лайка на фотографии -  \(error.localizedDescription)")
                self.view?.showChangeLikeErrorAlert()
            }
        }
    }
    
    private func subscribeToNotifications() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            let oldCount = photos.count
            let newCount = imagesListService.photos.count
            self.photos = self.imagesListService.photos
            self.view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    private func fetchPhotos() {
        imagesListService.fetchPhotosNextPage()
    }
}
