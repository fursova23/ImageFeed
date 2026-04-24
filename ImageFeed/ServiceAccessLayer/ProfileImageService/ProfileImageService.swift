import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    private init() {}
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        task?.cancel()
        
        guard let token = tokenStorage.token else {
            print("Bearer токен отсутствует в UserDefaults")
            completion(.failure(NSError(domain: "ProfileImageService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Ошибка авторизации"])))
            return
        }
        
        guard let request = makeProfileImageRequest(username: username, token: token) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
            case .success(let data):
                guard let self else { return }
                let imageURL = data.profileImage.small
                self.avatarURL = imageURL
                completion(.success(imageURL))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": imageURL]
                )
            case .failure(let error):
                print("[fetchProfileImageURL]: \(error.localizedDescription)")
                completion(.failure(error))
            }
            
            self?.task = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeProfileImageRequest(username: String, token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURLString)/users/\(username)") else {
            print("Ошибка создания URL для запроса аватара пользователя")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
}

