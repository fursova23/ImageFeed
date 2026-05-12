import Foundation

protocol ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol! { get set }
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func reloadRow(at indexPath: IndexPath)
    func showChangeLikeErrorAlert()
}
