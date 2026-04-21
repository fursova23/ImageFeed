import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private init() {
    }

    var token: String? {
        get {
            return KeychainWrapper.standard.string(forKey: Constants.bearerTokenKey)
        }
        set {
            if let token = newValue {
                KeychainWrapper.standard.set(token, forKey: Constants.bearerTokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Constants.bearerTokenKey)
            }
        }
    }
    
}
