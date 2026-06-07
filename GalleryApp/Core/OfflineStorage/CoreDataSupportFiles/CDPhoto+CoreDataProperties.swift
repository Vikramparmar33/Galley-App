//
//  CDPhoto+CoreDataProperties.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 07/06/26.
//
//

import Foundation
import CoreData


extension CDPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPhoto> {
        return NSFetchRequest<CDPhoto>(entityName: "CDPhoto")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var photoId: Int64

}

extension CDPhoto : Identifiable {

}

extension CDPhoto {

    func convertToPhoto() -> Photo? {
        guard let imageURL = self.imageURL else {
            return nil
        }

        return Photo(
            photoId: String(self.photoId),
            downloadURL: imageURL,
            imageData: self.imageData
        )
    }
}
