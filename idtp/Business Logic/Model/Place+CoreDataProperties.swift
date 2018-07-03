//
//  Place+CoreDataProperties.swift
//  idtp
//
//  Created by Apple on 27.03.2018.
//  Copyright © 2018 md. All rights reserved.
//
//

import Foundation
import CoreData

extension Place {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Place> {
        return NSFetchRequest<Place>(entityName: "Place")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var placeFull: String?
    @NSManaged public var placeName: String?
    @NSManaged public var accident: Accident?

}
