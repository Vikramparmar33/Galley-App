//
//  PhotoDataRepository.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

import CoreData
import UIKit

protocol PhotoRepository {
    func save(photos: [Photo])
    func getAll() -> [Photo]
    func getPhotosForPage(page: Int) -> [Photo]
}

struct PhotoDataRepository : PhotoRepository {

    /// Background thread par saare photos upsert karke ek hi baar save karo.
    func save(photos: [Photo]) {

        PersistentStorage.shared.performBackgroundTask { context in

            photos.forEach { insert($0, in: context) }

            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    debugPrint("CoreData background save error:", error)
                }
            }
        }
    }

    private func insert(_ photo: Photo, in context: NSManagedObjectContext) {

        let request = NSFetchRequest<CDPhoto>(entityName: "CDPhoto")
        request.predicate = NSPredicate(format: "photoId == %@", photo.photoId)
        request.fetchLimit = 1

        let cdPhoto: CDPhoto
        
        if let existing = (try? context.fetch(request))?.first {
            cdPhoto = existing
        } else {
            cdPhoto = CDPhoto(context: context)
            cdPhoto.id = UUID()
        }

        cdPhoto.photoId = Int64(photo.photoId) ?? 0
        cdPhoto.imageURL = photo.downloadURL
        
        // ADD THIS FOR OFFLINE SUPPORT
        cdPhoto.imageData = photo.imageData
        
    }
    
    func getAll() -> [Photo] {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDPhoto.self)
        var photos: [Photo] = []
        
        if let result = result {
            photos.append(contentsOf: result.compactMap { $0.convertToPhoto() })
        }
        
        return photos
    }
    
    func getPhotosForPage(page: Int) -> [Photo] {
        let request = CDPhoto.fetchRequest()
        request.fetchLimit = 20
        request.fetchOffset = (page - 1) * 20
        request.sortDescriptors = [
            NSSortDescriptor(key: "photoId", ascending: true)
        ]
        
        do {
            let result = try PersistentStorage.shared.context.fetch(request)
            return result.compactMap { $0.convertToPhoto() }
        } catch {
            debugPrint("Fetch error:", error)
            return []
        }
    }
    
}
