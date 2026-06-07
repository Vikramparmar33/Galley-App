//
//  GalleryService.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

final class GalleryService {
    
    static let shared = GalleryService()
    private init() {}
    
    func fetchPhotos(request: GalleryRequest) async throws -> [Photo] {

        let photos: [Photo] = try await APIManager.shared.request(
            endpoint: .list,
            parameters: request
        )

        return photos
    }
    
}
