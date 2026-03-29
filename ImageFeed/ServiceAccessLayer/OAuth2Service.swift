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
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseBody = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    self.tokenStorage.token = responseBody.accessToken
                    completion(.success(responseBody.accessToken))
                } catch {
                    print("Ошибка декодирования: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
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
        }
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
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
