//
//  PhotoDataRepository.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//

import Foundation

import CoreData

protocol PhotoRepository {
    func save(photos: [Photo])
    func getAll() -> [Photo]
}

struct PhotoDataRepository : PhotoRepository {

    /// Background thread par saare photos upsert karke ek hi baar save karo.
    func save(photos: [Photo]) {

        PersistentStorage.shared.performBackgroundTask { context in

            photos.forEach { upsert($0, in: context) }

            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    debugPrint("CoreData background save error:", error)
                }
            }
        }
    }

    private func upsert(_ photo: Photo, in context: NSManagedObjectContext) {

        let request = NSFetchRequest<CDPhoto>(entityName: "CDPhoto")
        request.predicate = NSPredicate(format: "id == %@", photo.id)
        request.fetchLimit = 1

        // Same context me fetch karo, warna object-context mismatch hoga.
        let cdPhoto = (try? context.fetch(request))?.first ?? CDPhoto(context: context)
        cdPhoto.id = photo.id
        cdPhoto.downloadURL = photo.downloadURL
    }
    
    func getAll() -> [Photo] {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDPhoto.self)
        var photos: [Photo] = []
        
        if let result = result {
            photos.append(contentsOf: result.compactMap { $0.convertToPhoto() })
        }
        
        return photos
    }
    
    func fetchById(_ id: String) -> CDPhoto? {

        let fetchRequest = NSFetchRequest<CDPhoto>(entityName: "CDPhoto")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        
        do {
            return try PersistentStorage.shared.context.fetch(fetchRequest).first
        } catch {
            debugPrint("FetchById error:", error)
            return nil
        }
    }
    
}
