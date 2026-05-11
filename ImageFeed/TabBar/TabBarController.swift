import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    // MARK: - Private Methods
    
    private func setupTabBar() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        guard let imagesListVC = storyboard.instantiateViewController(
            withIdentifier: "ImagesListViewController"
        ) as? ImagesListViewController else {
            assertionFailure("ImagesListViewController not found")
            return
        }
        
        let imagesListPresenter = ImagesListPresenter()
        imagesListVC.configure(imagesListPresenter)
        
        let profileVC = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileVC.configure(profilePresenter)
        
        imagesListVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        
        profileVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(resource: .tabProfileActive),
            selectedImage: nil
        )
        
        let imagesNav = UINavigationController(rootViewController: imagesListVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        viewControllers = [imagesNav, profileNav]
    }
    
}
