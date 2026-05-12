import Foundation

final class ProfilePresenter: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    
    private final let profileService = ProfileService.shared
    private final let profileImageService = ProfileImageService.shared
    private final let profileLogoutService = ProfileLogoutService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        subscribeToAvatarUpdates()
        updateAvatar()
        updateProfileDetails()
    }
    
    func updateAvatar() {
        guard let profileImageURL = profileImageService.avatarURL,
              let imageURL = URL(string: profileImageURL)
        else { return }
        view?.updateAvatar(imageURL: imageURL)
    }
    
    func updateProfileDetails() {
        guard let profile = profileService.profile else { return }
        
        let name = profile.name.isEmpty
            ? "Имя не указано"
            : profile.name
        let login = profile.loginName.isEmpty
            ? "@неизвестный_пользователь"
            : profile.loginName
        let status = (profile.bio?.isEmpty ?? true)
            ? "Профиль не заполнен"
            : profile.bio
        view?.updateProfileDetails(name: name, login: login, bio: status)
    }
    
    func subscribeToAvatarUpdates() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) {
            [weak self] _ in
            guard let self else { return }
            self.updateAvatar()
        }
    }
    
    func didTapLogout() {
        profileLogoutService.logout()
    }
}
