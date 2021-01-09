//
//  Pin+CoreDataProperties.swift
//  virtualTouristt
//
//  Created by Jieun Bae on 1/7/21.
//
//

import Foundation
import CoreData


extension Pin
    {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin>
    {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var photo: NSSet?

    }

    extension Pin : Identifiable {

    }
