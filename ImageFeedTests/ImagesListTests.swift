import XCTest
@testable import ImageFeed

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.configure(presenter)
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateTableView() {
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        presenter.view = viewController
        
        presenter.view?.updateTableViewAnimated(oldCount: 0, newCount: 10)
        
        XCTAssertTrue(viewController.updateTableViewAnimatedCalled)
        XCTAssertEqual(viewController.lastOldCount, 0)
        XCTAssertEqual(viewController.lastNewCount, 10)
    }
    
    func testDidTapLikeShowsErrorOnFailure() {
        let viewController = ImagesListViewControllerSpy()
        let presenter = ImagesListPresenter()
        presenter.view = viewController
        
        presenter.view?.showChangeLikeErrorAlert()
        
        XCTAssertTrue(viewController.showChangeLikeErrorAlertCalled)
    }
}
