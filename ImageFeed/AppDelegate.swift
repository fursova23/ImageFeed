import UIKit
import CoreData
import ProgressHUD

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageFeed")
        
        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("CoreData error: \(error)")
            }
        }
        
        return container
    }()
    
    // MARK: - UIApplicationDelegate
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureProgressHUD()
        return true
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        
        let sceneConfiguration = UISceneConfiguration(
            name: "Main",
            sessionRole: connectingSceneSession.role
        )
        sceneConfiguration.delegateClass = SceneDelegate.self
        
        return sceneConfiguration
    }
    
    // MARK: - Core Data
    func saveContext () {
        let context = persistentContainer.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            assertionFailure("Failed to save context: \(error)")
        }
    }
    
    // MARK: - Private Methods
    private func configureProgressHUD() {
        ProgressHUD.animationType = .activityIndicator
        ProgressHUD.colorHUD = .white
        ProgressHUD.colorAnimation = .black
    }
}
