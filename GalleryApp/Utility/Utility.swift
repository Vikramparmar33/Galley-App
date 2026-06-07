//
//  Utility.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation
import Reachability

class Utility: NSObject {
    
    // MARK: reachability
    class func isInternetAvailable() -> Bool {
        do {
               let reachability = try Reachability()
               return reachability.connection != .unavailable
           } catch {
               print("Unable to create Reachability: \(error)")
               return false
           }
    }
    
}

//MARK: - Tokens (Stored in Keychain)
extension Utility {

    /// Get Access Token
    class func getAccessToken() -> String? {
        return KeychainManager.loadString(key: KeychainManager.KeychainKey.accessToken)
    }

    /// Save Access Token
    class func saveAccessToken(_ accessToken: String) {
        KeychainManager.save(key: KeychainManager.KeychainKey.accessToken, value: accessToken)
    }

}
