//
//  GoogleUserData.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

struct GoogleUser: Codable {
    let userId: String
    let email: String
    let name: String
    let givenName: String
    let familyName: String
    let profileImageURL: String
}
