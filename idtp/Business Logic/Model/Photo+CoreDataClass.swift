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
    case driverLicensePage1Participant1                     = 0
    case driverLicensePage2Participant1                     = 1
    case certificateOfVehicleRegistrationPage1Participant1  = 2
    case certificateOfVehicleRegistrationPage2Participant1  = 3
    case insuranceParticipant1                              = 4
    
    case driverLicensePage1Participant2                     = 5
    case driverLicensePage2Participant2                     = 6
    case certificateOfVehicleRegistrationPage1Participant2  = 7
    case certificateOfVehicleRegistrationPage2Participant2  = 8
    case insuranceParticipant2                              = 9
    
    case carFrontLeftParticipant1                           = 10
    case carFrontRightParticipant1                          = 11
    case carBackLeftParticipant1                            = 12
    case carBackRightParticipant1                           = 13
    
    case carFrontLeftParticipant2                           = 14
    case carFrontRightParticipant2                          = 15
    case carBackLeftParticipant2                            = 16
    case carBackRightParticipant2                           = 17
    
    case additionalPhoto1                                   = 18
    case additionalPhoto2                                   = 19
    
    case dtpBlankPage1                                      = 20
    case dtpBlankPage2                                      = 21
    
    public var title: String {
        switch self {
        case .driverLicensePage1Participant1,
             .driverLicensePage1Participant2:
            return "ВУ 1 стр"
        case .driverLicensePage2Participant1,
             .driverLicensePage2Participant2:
            return "ВУ 2 стр"
        case .certificateOfVehicleRegistrationPage1Participant1,
             .certificateOfVehicleRegistrationPage1Participant2:
            return "Свид-во регистрации ТС 1 стр"
        case .certificateOfVehicleRegistrationPage2Participant1,
             .certificateOfVehicleRegistrationPage2Participant2:
            return "Свид-во регистрации ТС 2 стр"
        case .insuranceParticipant1,
             .insuranceParticipant2:
            return "Страховка"
        case .carFrontLeftParticipant1,
             .carFrontLeftParticipant2:
            return "Фото авто спереди слева"
        case .carFrontRightParticipant1,
             .carFrontRightParticipant2:
            return "Фото авто спереди справа"
        case .carBackLeftParticipant1,
             .carBackLeftParticipant2:
            return "Фото авто сзади слева"
        case .carBackRightParticipant1,
             .carBackRightParticipant2:
            return "Фото авто сзади справа"
        case .additionalPhoto1,
             .additionalPhoto2:
            return "Доп. фото"
        case .dtpBlankPage1:
            return "Фото заполненного бланка Извещения о ДТП стр.1"
        case .dtpBlankPage2:
            return "Фото заполненного бланка Извещения о ДТП стр.2"
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
