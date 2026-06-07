//
//  PhotoManager.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

struct PhotoManager {
    
    private let photoDataRepository = PhotoDataRepository()
    
    func savePhotos(photo: [Photo]) {
        photoDataRepository.save(photos: photo)
    }
    
    func fetchPhoto() -> [Photo] {
        return photoDataRepository.getAll()
    }
    
    func fetchPhotosForPage(page: Int) -> [Photo] {
        return photoDataRepository.getPhotosForPage(page: page)
    }
}
