import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private var keychainWrapper = KeychainWrapper.standard
    var token: String? {
        get {
            keychainWrapper.string(forKey: "token")
        }
        set {
            guard let token = newValue else {
                keychainWrapper.removeObject(forKey: "token")
                return
            }
            let isSuccess = keychainWrapper.set(token, forKey: "token")
            guard isSuccess else {
                return
            }
        }
    }
}
