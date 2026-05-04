import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private let urlSession = URLSession.shared
    private let tokenStorage = OAuth2TokenStorage.shared
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var fetchPhotosTask: URLSessionTask?
    private var changeLikeTask: URLSessionTask?
    private let perPage = 10
    
    private init() {}
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        if changeLikeTask != nil {
            return
        }
        
        guard let token = tokenStorage.token else {
            print("Bearer токен не найден")
            return
        }
        
        guard let request = makeChangeLikeRequest(photoId: photoId, isLike: isLike, token: token) else {
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<LikeResult, Error>) in
            guard let self else { return }
            switch result {
            case .success:
                if let index = self.photos.firstIndex(where: { $0.id == photoId } ) {
                    let photo = self.photos[index]
                    let updatedPhoto = photo.withLiked(isLike)
                    
                    self.photos = self.photos.withReplaced(itemAt: index, newValue: updatedPhoto)
                    completion(.success(()))
                }
            case .failure(let error):
                print("[ImagesListService.changeLike]: \(error.localizedDescription)")
                completion(.failure(error))
            }
            self.changeLikeTask = nil
        }
        
        self.changeLikeTask = task
        task.resume()
    }
    
    func fetchPhotosNextPage() {
        if fetchPhotosTask != nil {
            return
        }
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        lastLoadedPage = nextPage
        
        guard let token = tokenStorage.token else {
            print("Bearer токен не найден")
            return
        }
        
        guard let request = makeImageListRequest(page: nextPage, perPage: perPage, token: token) else {
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                let photos = data.map({Photo(from: $0)})
                self.photos.append(contentsOf: photos)
                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification,
                    object: self,
                    userInfo: nil
                )
            case .failure(let error):
                print("[ImagesListService.fetchPhotosNexPage]: \(error.localizedDescription)")
            }
            self.fetchPhotosTask = nil
        }
        
        self.fetchPhotosTask = task
        task.resume()
    }
    
    func clean() {
        photos = []
        lastLoadedPage = nil
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
    
    private func makeChangeLikeRequest(photoId: String, isLike: Bool, token: String) -> URLRequest? {
        guard let url = URL(string: "\(Constants.defaultBaseURLString)/photos/\(photoId)/like") else {
            print("Ошибка создания URL для запроса изменения лайка фотографии")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return request
    }
}
