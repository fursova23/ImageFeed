import UIKit

final class ImageListService {
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private let perPage = 10
    
    static let shared = ImageListService()
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    
    private init() {}
    
    func fetchPhotosNexPage() {
        if task != nil {
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        lastLoadedPage = nextPage
        
        guard let token = tokenStorage.token else {
            print("Bearer токен не найден")
//            completion(.failure(NSError(domain: "ImageListService", code: 401, userInfo: [NSLocalizedDescriptionKey: "Ошибка авторизации"])))
            return
        }
        
        guard let request = makeImageListRequest(page: nextPage, perPage: perPage, token: token) else {
//            completion(.failure(URLError(.badURL)))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            switch result {
            case .success(let data):
                guard let self else { return }
                let photos = data.map({Photo(from: $0)})
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: photos)
                    NotificationCenter.default.post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: nil
                    )
//                    completion(.success(photos))
                }
                
            case .failure(let error):
                print("[fetchPhotosNexPage]: \(error.localizedDescription)")
//                completion(.failure(error))
            }
            
            self?.task = nil
        }
        
        self.task = task
        task.resume()
        
    }
    
    private func makeImageListRequest(page pageNumber: Int, perPage count: Int, token: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "\(Constants.defaultBaseURLString)/photos") else {
            print("Ошибка создания URLComponents для запроса получения ленты фотографий")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(pageNumber)),
            URLQueryItem(name: "per_page", value: String(count)),
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
}
