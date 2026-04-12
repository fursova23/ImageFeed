import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    
    private var lastCode: String?
    
    private let tokenStorage = OAuth2TokenStorage.shared
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard lastCode != code else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard let request = makeOAuthTokenRequest(code: code) else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                let token = data.accessToken
                tokenStorage.token = token
                completion(.success(token))
            case .failure(let error):
                self.handleError(error, completion: completion)
            }
            self.task = nil
            self.lastCode = nil
        }
        
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashTokenURLString) else {
            assertionFailure("Ошибка создания URLComponents из строки: \(WebViewConstants.unsplashTokenURLString)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        
        guard let authTokenUrl = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: authTokenUrl)
        request.httpMethod = "POST"
        return request
    }
    
    private func handleError(_ error: Error, completion: @escaping (Result<String, Error>) -> Void) {
        switch error {
            
        case NetworkError.httpStatusCode(let statusCode):
            print("[fetchOAuthToken]: NetworkError - код ошибки \(statusCode)")
            
        case NetworkError.urlRequestError(let requestError):
            print("[fetchOAuthToken]: NetworkError - \(requestError.localizedDescription)")
            
        case NetworkError.urlSessionError:
            print("[fetchOAuthToken]: NetworkError - urlSessionError")
            
        default:
            print("[fetchOAuthToken]: Unsplash error -  \(error.localizedDescription)")
        }
        
        completion(.failure(error))
    }
    
}
