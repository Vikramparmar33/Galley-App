//
//  UserDefaultsManager.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

final class UserDefaultsManager {

    private init() {}

    private enum Keys {
        static let googleUser = "googleUser"
        static let isLoggedIn = "isLoggedIn"
    }

    // MARK: - Save Google User
    static func saveGoogleUser(_ user: GoogleUser) {
        do {
            let data = try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: Keys.googleUser)
            UserDefaults.standard.set(true, forKey: Keys.isLoggedIn)
        } catch {
            print("Failed to save Google user: \(error)")
        }
    }

    // MARK: - Get Google User
    static func getGoogleUser() -> GoogleUser? {
        guard let data = UserDefaults.standard.data(forKey: Keys.googleUser) else {
            return nil
        }

        do {
            return try JSONDecoder().decode(GoogleUser.self, from: data)
        } catch {
            print("Failed to fetch Google user: \(error)")
            return nil
        }
    }

    // MARK: - Check Login Status
    static func isLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isLoggedIn)
    }

    // MARK: - Clear User Data (Logout)
    static func clearGoogleUser() {
        UserDefaults.standard.removeObject(forKey: Keys.googleUser)
        UserDefaults.standard.removeObject(forKey: Keys.isLoggedIn)
    }
}
