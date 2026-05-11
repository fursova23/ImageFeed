import Foundation

final class AuthHelper: AuthHelperProtocol {
    let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standart) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest? {
        guard let url = authURL() else { return nil }
        
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
            components.path == "/oauth/authorize/native",
            let code = components.queryItems?
                .first(where: { $0.name == "code" })?
                .value
        else {
            return nil
        }
        return code
    }
    
    func authURL() -> URL? {
        guard var urlComponents = URLComponents(string: configuration.authURLString) else {
            print("Ошибка создания URLComponents из строки: \(configuration.authURLString)")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: configuration.accessKey),
            URLQueryItem(name: "redirect_uri", value: configuration.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: configuration.accessScope),
        ]
        
        return urlComponents.url
    }
}
