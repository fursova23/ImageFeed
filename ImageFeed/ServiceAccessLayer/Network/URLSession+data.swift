import Foundation

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void)
    -> URLSessionTask {
        
        let completeOnMain: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            
            if let error = error {
                completeOnMain(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            guard
                let data,
                let httpResponse = response as? HTTPURLResponse
            else {
                completeOnMain(.failure(NetworkError.urlSessionError))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (200 ..< 300).contains(statusCode) else {
                print(String(data: data, encoding: .utf8))
                completeOnMain(.failure(NetworkError.httpStatusCode(statusCode)))
                return
            }
            
            completeOnMain(.success(data))
        })
        
        return task
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let decoded = try decoder.decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    print("[objectTask]: Ошибка декодирования - \(error.localizedDescription). Данные: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("[objectTask]: Ошибка выполнения запроса - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        return task
    }
}

