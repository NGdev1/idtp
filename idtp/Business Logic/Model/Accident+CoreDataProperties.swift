//
//  Accident+CoreDataProperties.swift
//  idtp
//
//  Created by Apple on 03.04.2018.
//  Copyright © 2018 md. All rights reserved.
//
//

import Foundation
import CoreData


extension Accident {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Accident> {
        return NSFetchRequest<Accident>(entityName: "Accident")
    }

    @NSManaged public var additionalPhotosRequired: Int32
    @NSManaged public var dateTime: NSDate?
    @NSManaged public var gibddResponce: String?
    @NSManaged public var registerId: Int32
    @NSManaged public var stateValue: Int32
    @NSManaged public var isSmsSent: Bool
    @NSManaged public var additionalPhotos: NSSet?
    @NSManaged public var participantOne: Participant?
    @NSManaged public var participantTwo: Participant?
    @NSManaged public var place: Place?

}

// MARK: Generated accessors for additionalPhotos
extension Accident {

    @objc(addAdditionalPhotosObject:)
    @NSManaged public func addToAdditionalPhotos(_ value: Photo)

    @objc(removeAdditionalPhotosObject:)
    @NSManaged public func removeFromAdditionalPhotos(_ value: Photo)

    @objc(addAdditionalPhotos:)
    @NSManaged public func addToAdditionalPhotos(_ values: NSSet)

    @objc(removeAdditionalPhotos:)
    @NSManaged public func removeFromAdditionalPhotos(_ values: NSSet)

}
