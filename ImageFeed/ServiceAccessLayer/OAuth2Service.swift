import Foundation

final class OAuth2Service {
    
    static let shared = OAuth2Service()
    
    private let tokenStorage = OAuth2TokenStorage()
    
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.invalidRequest))
            }
            return
        }
        
        let task = URLSession.shared.data(for: request) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let data):
                self.handleSuccess(data: data, completion: completion)
            case .failure(let error):
                handleError(error, completion: completion)
            }
        }
        
        task.resume()
    }
    
    private func handleSuccess(data: Data, completion: @escaping (Result<String, Error>) -> Void) {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
            tokenStorage.token = responseBody.accessToken
            
            completion(.success(responseBody.accessToken))
        } catch {
            print("Ошибка декодирования: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    private func handleError(_ error: Error, completion: @escaping (Result<String, Error>) -> Void) {
        
        switch error {
            
        case NetworkError.httpStatusCode(let statusCode):
            print("HTTP-ошибка: статус \(statusCode)")
            
        case NetworkError.urlRequestError(let requestError):
            print("Сетевая ошибка: \(requestError.localizedDescription)")
            
        case NetworkError.urlSessionError:
            print("Ошибка URLSession")
            
        default:
            print("Ошибка Unsplash: \(error.localizedDescription)")
        }
        
        completion(.failure(error))
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashTokenURLString) else {
            print("Ошибка создания URLComponents из строки: \(WebViewConstants.unsplashTokenURLString)")
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
    
}
