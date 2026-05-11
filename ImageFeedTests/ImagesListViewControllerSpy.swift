import Foundation
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol!
    
    var updateTableViewAnimatedCalled = false
    var reloadRowCalled = false
    var showChangeLikeErrorAlertCalled = false
    
    var lastOldCount: Int?
    var lastNewCount: Int?
    var lastReloadedIndexPath: IndexPath?
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
        lastOldCount = oldCount
        lastNewCount = newCount
    }
    
    func reloadRow(at indexPath: IndexPath) {
        reloadRowCalled = true
        lastReloadedIndexPath = indexPath
    }
    
    func showChangeLikeErrorAlert() {
        showChangeLikeErrorAlertCalled = true
    }
}
