//
//  ProfileImageService.swift
//  unsplash_practice
//
//  Created by Денис Петров on 22.09.2024.
//

import Foundation


final class ProfileImageService {
    
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    
    private(set) var avatarURL: String?
    private var oAuth2Service = OAuth2Service.shared
    private var task: URLSessionTask?
    
    struct UserResult: Codable {
        let profileImage: ImageSize
        
        enum CodingKeys: String, CodingKey {
            case profileImage = "profile_image"
        }
    }
    
    struct ImageSize: Codable {
        let small: String
        let medium: String
        let large: String
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>)-> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        let urlRequest = makeImageRequest(username: username)
        
        guard let urlRequest = urlRequest else { return }
        let session = URLSession.shared
        let task = session.objectTask(for: urlRequest) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let imagePack):
                let smallImage = imagePack.profileImage.small
                self.avatarURL = smallImage
                completion(.success(smallImage))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": smallImage])
            }
        }
        
        task.resume()
        
    }
    
    func makeImageRequest(username: String) -> URLRequest? {
        var urlRequest = URLRequest.makeHTTPRequest(
            path: "/users/"
            + "\(username)",
            httpMethod: "GET",
            baseURL: Constants.defaultBaseURL)
        
        guard let token = oAuth2Service.authToken else { return nil }
        
        urlRequest?.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return urlRequest
    }
}