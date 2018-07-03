//
//  DataCheck.swift
//  idtp
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

class DataCheck {
    
    static func checkAccident(_ accident : Accident) -> String? {
        if accident.place == nil {
            return "Укажите место ДТП"
        }
        
        if accident.dateTime == nil {
            return "Укажите время ДТП"
        }
        
        if let participantOnePhone = accident.participantOne!.driversPhone {
            if participantOnePhone.isEmpty {
                return "Укажите номер телефона участника А"
            }
        } else {
            return "Укажите номер телефона участника А"
        }
        
        if let participantTwoPhone = accident.participantTwo!.driversPhone {
            if participantTwoPhone.isEmpty {
                return "Укажите номер телефона участника Б"
            }
        } else {
            return "Укажите номер телефона участника Б"
        }
        
        let photosRequired = accident.additionalPhotosRequired + 18
        if accident.countOfAllPhotos() != photosRequired {
            
            return "Не хватает фотографий"
        }
        
        return nil
    }
    
    static func checkDriversPhone(_ driversPhone : String) -> String? {
        
        if driversPhone.isEmpty {
            return nil
        } else if !validatePhoneNumber(driversPhone) {
            return "Введите телефон в правильном формате"
        }
        
        return nil
    }
    
    static func checkConfirmationInputs(_ codeOne : String,
                                        _ codeTwo : String) -> String? {
        if codeOne.isEmpty {
            return "Введите код первого участника"
        } else if !validateConfirmationInput(codeOne) {
            return "Введите код первого участника в правильном формате"
        }
        
        if codeTwo.isEmpty {
            return "Введите код второго участника"
        } else if !validateConfirmationInput(codeTwo) {
            return "Введите код второго участника в правильном формате"
        }
        
        return nil
    }
    
    private static func validateConfirmationInput(_ candidate: String) -> Bool {
        let regex = "[0-9]{6}"
        
        let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)
        
        return isValid
    }
    
    private static func validatePhoneNumber(_ candidate: String) -> Bool {
        let phoneNumberRegex = "\\d{10}"
        
        let isValid = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex).evaluate(with: candidate)
        
        return isValid
    }
}
