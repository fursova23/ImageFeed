import Foundation

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    
    func viewDidLoad()
    func didScrollToLastCell()
    func didTapLike(at indexPath: IndexPath, cell: ImagesListCell)
    func photo(at IndexPath: IndexPath) -> Photo
}
