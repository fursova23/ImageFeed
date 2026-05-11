import Foundation

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func updateAvatar()
    func didTapLogout()
}
