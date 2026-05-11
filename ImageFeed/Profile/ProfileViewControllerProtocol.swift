import Foundation

protocol ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol! { get set }
    
    func updateAvatar(imageURL: URL)
    func updateProfileDetails(name: String, login: String, bio: String?)
}
