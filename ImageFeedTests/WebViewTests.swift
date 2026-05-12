import XCTest
@testable import ImageFeed

final class WebViewTests: XCTestCase {
    
    // MARK: - Properties
    
    private var presenter: WebViewPresenter!
    private var viewController: WebViewViewControllerSpy!
    private var authHelper: AuthHelper!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        
        authHelper = AuthHelper()
        presenter = WebViewPresenter(authHelper: authHelper)
        viewController = WebViewViewControllerSpy()
        
        presenter.view = viewController
        viewController.presenter = presenter
    }
    
    override func tearDown() {
        presenter = nil
        viewController = nil
        authHelper = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testViewControllerCallsViewDidLoad() {
        // Given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "WebViewViewController"
        ) as! WebViewViewController
        
        let presenter = WebViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        _ = viewController.view
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        // Given
        let progress: Float = 0.6
        
        // When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // Then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        // Given
        let progress: Float = 1.0
        
        // When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        // Then
        XCTAssertTrue(shouldHideProgress)
    }
}
