import UIKit
import ProgressHUD

// MARK: - AuthViewController

final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AuthViewControllerDelegate?
    
    private let oauth2Service = OAuth2Service.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == WebViewConstants.showWebViewSegueIdentifier else {
            super.prepare(for: segue, sender: sender)
            return
        }
        
        guard let webViewViewController = segue.destination as? WebViewViewController else {
            assertionFailure("Failed to prepare for \(WebViewConstants.showWebViewSegueIdentifier)")
            return
        }
        
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        webViewViewController.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(resource: .navBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .navBackButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(resource: .ypBlackIOS)
        navigationItem.backBarButtonItem?.accessibilityIdentifier = "nav back button white"
    }
    
}

// MARK: - WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        
        navigationController?.popViewController(animated: true)
        
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self else { return }
            
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("[webViewViewController]: Не удалось получить токен - \(error.localizedDescription)")
                self.showAuthErrorAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

extension AuthViewController {
    func showAuthErrorAlert() {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Не удалось войти в систему",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }
}
