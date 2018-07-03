//
//  Photo+CoreDataClass.swift
//  idtp
//
//  Created by Apple on 23.02.2018.
//  Copyright © 2018 md. All rights reserved.
//
//

import Foundation
import CoreData

enum PhotoType: Int32 {
    case driverLicensePage1                     = 0
    case driverLicensePage2                     = 1
    case certificateOfVehicleRegistrationPage1  = 2
    case certificateOfVehicleRegistrationPage2  = 3
    case insurance                              = 4
    
    case carFrontLeft                           = 5
    case carFrontRight                          = 6
    case carBackLeft                            = 7
    case carBackRight                           = 8
    
    case additionalPhoto                        = 9
    
    public var title: String {
        switch self {
        case .driverLicensePage1:
            return "ВУ 1 стр"
        case .driverLicensePage2:
            return "ВУ 2 стр"
        case .certificateOfVehicleRegistrationPage1:
            return "Свид-во регистрации ТС 1 стр"
        case .certificateOfVehicleRegistrationPage2:
            return "Свид-во регистрации ТС 2 стр"
        case .insurance:
            return "Страховка"
        case .carFrontLeft:
            return "Фото авто спереди слева"
        case .carFrontRight:
            return "Фото авто спереди справа"
        case .carBackLeft:
            return "Фото авто сзади слева"
        case .carBackRight:
            return "Фото авто сзади справа"
        case .additionalPhoto:
            return "Доп. фото"
        }
    }
}

@objc(Photo)
public class Photo: NSManagedObject {
    var type : PhotoType {
        get {
            return PhotoType(rawValue: self.typeValue)!
        }
        
        set {
            self.typeValue = newValue.rawValue
        }
    }
}
