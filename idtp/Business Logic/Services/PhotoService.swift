//
//  PhotoService.swift
//  idtp
//
//  Created by Apple on 21.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

class PhotoService {
    static func createPhoto() -> Photo {
        return Photo(entity: Photo.entity(),
                             insertInto: PersistenceService.context)
    }
}
