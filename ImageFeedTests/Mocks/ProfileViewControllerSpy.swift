import Foundation
@testable import ImageFeed

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol!
    
    var updateAvatarCalled = false
    var updateProfileDetailsCalled = false
    
    var lastAvatarURL: URL?
    var lastName: String?
    var lastLogin: String?
    var lastBio: String?
    
    
    func updateAvatar(imageURL: URL) {
        updateAvatarCalled = true
        lastAvatarURL = imageURL
    }
    
    func updateProfileDetails(name: String, login: String, bio: String?) {
        updateProfileDetailsCalled = true
        lastName = name
        lastLogin = login
        lastBio = bio
    }
}
