//
//  CDPhoto+CoreDataProperties.swift
//  GalleryApp
//
//  Created by Vikram's Macbook on 06/06/26.
//
//

import Foundation
import CoreData


extension CDPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPhoto> {
        return NSFetchRequest<CDPhoto>(entityName: "CDPhoto")
    }

    @NSManaged public var id: String?
    @NSManaged public var downloadURL: String?

}

extension CDPhoto : Identifiable {

}

extension CDPhoto {
    
    func convertToPhoto() -> Photo? {
        guard let id = self.id,
              let downloadURL = self.downloadURL else {
            return nil
        }
        
        return Photo(
            id: id,
            downloadURL: downloadURL
        )
    }
    
}
