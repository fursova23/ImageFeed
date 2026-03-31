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

