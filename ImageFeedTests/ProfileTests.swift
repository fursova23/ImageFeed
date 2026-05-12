import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.configure(presenter)
        
        _ = viewController.view
        
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateAvatar() {
        let viewController = ProfileViewControllerSpy()
        
        viewController.updateAvatar(imageURL: URL(string: "https://example.com")!)
        
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
}
