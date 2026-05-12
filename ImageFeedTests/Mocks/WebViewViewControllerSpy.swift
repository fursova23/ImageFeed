import Foundation
import ImageFeed

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    
    var presenter: WebViewPresenterProtocol?
    
    // MARK: - Load Request
    
    var loadRequestCalled = false
    
    // MARK: - Progress Value
    
    private(set) var setProgressValueCalled = false
    private(set) var progressValue: Float?
    
    // MARK: - Progress Hidden
    
    private(set) var setProgressHiddenCalled = false
    private(set) var isProgressHidden: Bool?
    
    func load(request: URLRequest) {
        loadRequestCalled = true
    }
    
    func setProgressValue(_ newValue: Float) {
        setProgressValueCalled = true
        progressValue = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        setProgressHiddenCalled = true
        isProgressHidden = isHidden
    }
}
