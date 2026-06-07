//
//  ProfileVM.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

final class ProfileViewModel {

    // MARK: - Variables
    private(set) var user: GoogleUser?

    // MARK: - Load User
    func loadUser() {
        user = UserDefaultsManager.getGoogleUser()
    }

    // MARK: - User Info
    var name: String {
        user?.name ?? ""
    }

    var email: String {
        user?.email ?? ""
    }

    var profileImageURL: String {
        user?.profileImageURL ?? ""
    }

    var userId: String {
        user?.userId ?? ""
    }

    // MARK: - Logout
    func clearUser() {
        UserDefaultsManager.clearGoogleUser()
        KeychainManager.clearAuthTokens()
    }
}
