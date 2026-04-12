import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()

    var token: String? {
        get {
            UserDefaults.standard.string(forKey: Constants.bearerTokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.bearerTokenKey)
        }
    }
    
}
