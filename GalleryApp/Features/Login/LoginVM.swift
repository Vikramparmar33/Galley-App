//
//  LoginVM.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation
import GoogleSignIn

final class LoginViewModel {
    
    // MARK: - Save User
    func saveUser(_ googleUser: GIDGoogleUser) {
        
        let user = GoogleUser(
            userId: googleUser.userID ?? "",
            email: googleUser.profile?.email ?? "",
            name: googleUser.profile?.name ?? "",
            givenName: googleUser.profile?.givenName ?? "",
            familyName: googleUser.profile?.familyName ?? "",
            profileImageURL: googleUser.profile?.imageURL(withDimension: 200)?.absoluteString ?? ""
        )
        
        // Save Access Token
        Utility.saveAccessToken(googleUser.accessToken.tokenString)
      
        // Save User Data
        UserDefaultsManager.saveGoogleUser(user)
    }
    
    // MARK: - Get User
    func getUser() -> GoogleUser? {
        guard let user = UserDefaultsManager.getGoogleUser() else { return nil }
        return user
    }
    
}
