import Foundation

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
            let fulfillCOmpletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            let task = dataTask(with: request, completionHandler: { data, response, error in
                if let data, let response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if (200 ..< 300) ~= statusCode {
                        fulfillCOmpletionOnTheMainThread(.success(data))
                    } else {
                        print(String(data: data, encoding: .utf8))
                        fulfillCOmpletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                    }
                } else if let error = error {
                    fulfillCOmpletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
                } else {
                    fulfillCOmpletionOnTheMainThread(.failure(NetworkError.urlSessionError))
                }
            })
            return task
        }
}

