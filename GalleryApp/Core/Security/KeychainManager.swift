//
//  KeychainManager.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation
import Security

final class KeychainManager {

    private static let serviceName = "com.galleryapp.mobile.app"

    // MARK: - Save

    @discardableResult
    static func save(key: String, value: String) -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        return save(key: key, data: data)
    }

    @discardableResult
    static func save(key: String, data: Data) -> Bool {
        // Delete existing item first to avoid duplicates
        delete(key: key)

        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String:  serviceName,
            kSecAttrAccount as String:  key,
            kSecValueData as String:    data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    // MARK: - Load

    static func loadString(key: String) -> String? {
        guard let data = loadData(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    static func loadData(key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String:  serviceName,
            kSecAttrAccount as String:  key,
            kSecReturnData as String:   kCFBooleanTrue!,
            kSecMatchLimit as String:   kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }
        return data
    }

    // MARK: - Delete

    @discardableResult
    static func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String:       kSecClassGenericPassword,
            kSecAttrService as String:  serviceName,
            kSecAttrAccount as String:  key
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }

    // MARK: - Delete All Auth Tokens

    static func clearAuthTokens() {
        delete(key: KeychainKey.accessToken)
        delete(key: KeychainKey.refreshToken)
        delete(key: KeychainKey.tokenType)
        delete(key: KeychainKey.expiresIn)
    }
}

// MARK: - Keychain Keys

extension KeychainManager {

    struct KeychainKey {
        static let accessToken  = "auth_access_token"
        static let refreshToken = "auth_refresh_token"
        static let tokenType    = "auth_token_type"
        static let expiresIn    = "auth_expires_in"
    }
}
