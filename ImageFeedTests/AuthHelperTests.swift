import XCTest
@testable import ImageFeed

final class AuthHelperTests: XCTestCase {
    
    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standart
        let authHelper = AuthHelper(configuration: .standart)
        
        let url = authHelper.authURL()
        
        guard let urlString = url?.absoluteString else {
            XCTFail("Auth URL is nil")
            return
        }
        
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
        XCTAssertTrue(urlString.contains("code"))
    }
    
    func testCodeFromURL() {
        let authHelper = AuthHelper()
        
        var urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")!
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url!
        
        let code = authHelper.code(from: url)
        
        XCTAssertEqual(code, "test code")
    }
}
