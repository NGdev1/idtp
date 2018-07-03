//
//  AccidentService.swift
//  idtp
//
//  Created by Apple on 18.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import CoreData

class AccidentService {
    static func createAccident() -> Accident {
        let accident = Accident(entity: Accident.entity(), insertInto: PersistenceService.context)
        
        accident.participantOne = ParticipantService.createParticipant()
        accident.participantTwo = ParticipantService.createParticipant()
        
        return accident
    }
    
    static func getAll() -> [Accident]? {
        do {
            let result = try PersistenceService.context.fetch(Accident.fetchRequest())
            return result as? [Accident]
        } catch let error as NSError {
            print("Could not load \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    static func isEditingAccidentExist() -> Bool {
        return getEditingAccident() != nil
    }
    
    static func getFinishedAccidents() -> [Accident]? {
        let context = PersistenceService.context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Accident")
        let predicate = NSPredicate(format: "stateValue = 3")
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return result as? [Accident]
            
        } catch let error as NSError {
            print("Could not load \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    static func getEditingAccident() -> Accident? {
        let context = PersistenceService.context
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Accident")
        let predicate = NSPredicate(format: "stateValue != 3")
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            if let accidentList = result as? [Accident] {
                if accidentList.count > 0 {
                    return accidentList[0]
                }
            }
        } catch let error as NSError {
            print("Could not load \(error), \(error.userInfo)")
        }
        
        return nil
    }
    
    static func delete(accident: Accident) {        
        if accident.participantOne != nil {
            if accident.participantOne!.photos != nil {
                for photo in accident.participantOne!.photos! {
                    DataManager.deleteImageFromCash(pathName: "Images",
                                                    fileName: (photo as! Photo).fileName!)
                }
            }
        }
        
        if accident.participantTwo != nil {
            if accident.participantTwo!.photos != nil {
                for photo in accident.participantTwo!.photos! {
                    DataManager.deleteImageFromCash(pathName: "Images",
                                                    fileName: (photo as! Photo).fileName!)
                }
            }
        }
        
        if accident.additionalPhotos != nil {
            for photo in accident.additionalPhotos! {
                DataManager.deleteImageFromCash(pathName: "Images",
                                                fileName: (photo as! Photo).fileName!)
            }
        }
        
        PersistenceService.context.delete(accident)
        PersistenceService.saveContext()
    }
}
