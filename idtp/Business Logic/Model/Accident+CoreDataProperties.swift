//
//  Accident+CoreDataProperties.swift
//  idtp
//
//  Created by Μιχαήλ Αντρέγιεφ on 04.09.2018.
//  Copyright © 2018 md. All rights reserved.
//
//

import Foundation
import CoreData


extension Accident {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Accident> {
        return NSFetchRequest<Accident>(entityName: "Accident")
    }

    @NSManaged public var dateTime: NSDate?
    @NSManaged public var gibddResponce: String?
    @NSManaged public var isSmsSent: Bool
    @NSManaged public var registerId: Int32
    @NSManaged public var stateValue: Int32
    @NSManaged public var photos: NSSet?
    @NSManaged public var participantOne: Participant?
    @NSManaged public var participantTwo: Participant?
    @NSManaged public var place: Place?

}

// MARK: Generated accessors for photos
extension Accident {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photo)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photo)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)

}
