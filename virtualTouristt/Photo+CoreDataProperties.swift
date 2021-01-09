//
//  Photo+CoreDataProperties.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 1/7/21.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo>
    {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var photoFile: Data?
    @NSManaged public var pin: Pin?

    }

    extension Photo : Identifiable {

    }
