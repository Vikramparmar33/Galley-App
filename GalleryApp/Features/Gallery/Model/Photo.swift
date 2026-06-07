//
//  Photo.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

struct Photo: Decodable, Sendable {
    let photoId: String
    let downloadURL: String
    var imageData: Data?   // optional for offline caching

    init(photoId: String, downloadURL: String, imageData: Data?) {
        self.photoId = photoId
        self.downloadURL = downloadURL
        self.imageData = imageData
    }
    
    enum CodingKeys: String, CodingKey {
        case photoId = "id"
        case downloadURL = "download_url"
    }
}
