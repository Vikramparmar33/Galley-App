//
//  Photo.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

struct Photo: Decodable, Sendable {
    let id: String
    let downloadURL: String

    init(id: String, downloadURL: String) {
        self.id = id
        self.downloadURL = downloadURL
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case downloadURL = "download_url"
    }
}
