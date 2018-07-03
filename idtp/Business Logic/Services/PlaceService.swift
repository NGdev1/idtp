//
//  PlaceService.swift
//  idtp
//
//  Created by Apple on 20.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import CoreData

class PlaceService {
    static func createPlace() -> Place {
        return Place(entity: Place.entity(), insertInto: PersistenceService.context)
    }
}
