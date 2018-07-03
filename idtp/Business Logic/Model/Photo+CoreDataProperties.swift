//
//  Photo+CoreDataProperties.swift
//  idtp
//
//  Created by Apple on 27.03.2018.
//  Copyright © 2018 md. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var fileName: String?
    @NSManaged public var isSent: Bool
    @NSManaged public var typeValue: Int32

}
