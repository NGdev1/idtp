//
//  Participant+CoreDataProperties.swift
//  idtp
//
//  Created by Μιχαήλ Αντρέγιεφ on 04.09.2018.
//  Copyright © 2018 md. All rights reserved.
//
//

import Foundation
import CoreData


extension Participant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Participant> {
        return NSFetchRequest<Participant>(entityName: "Participant")
    }

    @NSManaged public var driversPhone: String?
    @NSManaged public var stateValue: Int32

}
