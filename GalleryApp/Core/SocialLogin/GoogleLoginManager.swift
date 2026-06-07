//
//  GoogleLoginManager.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

import GoogleSignIn

protocol GoogleLoginDelegate: AnyObject {
    func onGoogleLoginSuccess(user: GIDGoogleUser)
    func onGoogleLoginFailure(error: NSError)
}

protocol GoogleLogoutDelegate: AnyObject {
    func onGoogleLogoutSuccess()
    func onGoogleLogoutFailure(error: NSError)
}

class GoogleLoginManager: NSObject {
    
    static let sharedInstance = GoogleLoginManager()
    weak var loginDelegate: GoogleLoginDelegate?
    weak var logoutDelegate: GoogleLogoutDelegate?
    
    private let clientID = AppEnvironment.googleClientID
    
    /// Initiates Google Sign-In flow
    func signIn(from viewController: UIViewController) {
        
        // Optional: sign out any existing session
        GIDSignIn.sharedInstance.signOut()
        
        guard Utility.isInternetAvailable() else {
            debugPrint("No internet connection.")
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                debugPrint("Google Sign-In Error:", error.localizedDescription)
                self.loginDelegate?.onGoogleLoginFailure(error: error as NSError)
                return
            }
            
            guard let user = result?.user else {
                debugPrint("Google Sign-In was canceled or failed to get user.")
                return
            }
            
            self.logUserDetails(user)
            self.loginDelegate?.onGoogleLoginSuccess(user: user)
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
        
        let isLoggedOut = GIDSignIn.sharedInstance.currentUser == nil
        
        if isLoggedOut {
            logoutDelegate?.onGoogleLogoutSuccess()
        } else {
            
            let error = NSError(
                domain: "GoogleSignOut",
                code: 1001,
                userInfo: [
                    NSLocalizedDescriptionKey: "Failed to sign out user."
                ]
            )
            
            logoutDelegate?.onGoogleLogoutFailure(error: error)
        }
    }
    
    /// Logs user details (for debugging)
    private func logUserDetails(_ user: GIDGoogleUser) {
        debugPrint("User ID: \(user.userID ?? "N/A")")
        debugPrint("Email: \(user.profile?.email ?? "N/A")")
        debugPrint("Name: \(user.profile?.name ?? "N/A")")
        debugPrint("Given Name: \(user.profile?.givenName ?? "N/A")")
        debugPrint("Family Name: \(user.profile?.familyName ?? "N/A")")
        debugPrint("Profile Pic URL: \(user.profile?.imageURL(withDimension: 150)?.absoluteString ?? "N/A")")
    }
    
}
