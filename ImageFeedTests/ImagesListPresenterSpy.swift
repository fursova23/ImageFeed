import Foundation
@testable import ImageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    let photosCount: Int = 0
    
    var viewDidLoadCalled = false
    var didScrollToLastCellCalled = false
    var didTapLikeCalled = false
    var photoCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didScrollToLastCell() {
        didScrollToLastCellCalled = true
    }
    
    func didTapLike(at indexPath: IndexPath, cell: ImageFeed.ImagesListCell) {
        didTapLikeCalled = true
    }
    
    func photo(at IndexPath: IndexPath) -> ImageFeed.Photo {
        Photo(id: "1", size: CGSize(width: 50, height: 50), createdAt: nil, welcomeDescription: nil, thumbImageURL: "", largeImageURL: "", isLiked: false)
    }
}
