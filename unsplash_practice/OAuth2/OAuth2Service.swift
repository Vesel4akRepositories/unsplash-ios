import Foundation

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private let urlSession = URLSession.shared
    private var currentTask: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            OAuth2TokenStorage().token = newValue
        }
    }
    
    private init() {}
    
    func fetchOAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void ){
            assert(Thread.isMainThread)
            if lastCode == code { return }
            lastCode = code
            currentTask?.cancel()
            lastCode = code
            
            guard let request = authTokenRequest(code: code) else {
                completion(.failure(NetworkError.urlRequestError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL request"]))))
                return
            }
            let task = object(for: request) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        completion(.success(response.accessToken))
                    case .failure(let error):
                        completion(.failure(error))
                        self.lastCode = nil
                    }
                    self.currentTask = nil
                }
            }
            currentTask = task
            task.resume()
        }
}

extension OAuth2Service {
    private func object(
        for request: URLRequest,
        completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                self.currentTask = nil
                completion(.success(body))
                self.lastCode = nil
            case .failure(let error):
                completion(.failure(error))
                self.currentTask = nil
                self.lastCode = nil
            }
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest? {
        guard let url = URL(string: "/oauth/token"
                            + "?client_id=\(Constants.accessKey)"
                            + "&&client_secret=\(Constants.secretKey)"
                            + "&&redirect_uri=\(Constants.redirectURI)"
                            + "&&code=\(code)"
                            + "&&grant_type=authorization_code",
                            relativeTo: URL(string: "https://unsplash.com")) else {
            print("Error creating URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return request
    }
}

extension URLRequest {
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL = Constants.defaultBaseURL
    ) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            print("Error creating URL")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}
