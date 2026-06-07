//
//  AppEnvironment.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 07/06/26.
//

import Foundation

struct AppEnvironment {

    private static let infoDictionary = Bundle.main.infoDictionary

    // MARK: - Server
    static var serverBaseURL: String {
        guard let url = infoDictionary?["SERVER_BASE_URL"] as? String, !url.isEmpty else {
            fatalError("SERVER_BASE_URL not set in Info.plist / xcconfig")
        }
        return url
    }
    
    // MARK: - Photo Thumbnail
    static var photoThumbnailURL: String {
        guard let url = infoDictionary?["PHOTO_THUMBNAIL_URL"] as? String, !url.isEmpty else {
            fatalError("PHOTO_THUMBNAIL_URL not set in Info.plist / xcconfig")
        }
        return url
    }

    // MARK: - Google
    static var googleClientID: String {
        guard let id = infoDictionary?["GOOGLE_CLIENT_ID"] as? String, !id.isEmpty else {
            fatalError("GOOGLE_CLIENT_ID not set in Info.plist / xcconfig")
        }
        return id
    }
}

