//
//  Accident+CoreDataClass.swift
//  idtp
//
//  Created by Apple on 18.02.2018.
//  Copyright © 2018 md. All rights reserved.
//
//

import Foundation
import CoreData

enum AccidentState : Int32 {
    case editing        = 0
    case checking       = 1
    case confirming     = 2
    case done           = 3
}

@objc(Accident)
public class Accident: NSManagedObject {
    var state : AccidentState {
        get {
            return AccidentState(rawValue: self.stateValue)!
        }
        
        set {
            self.stateValue = newValue.rawValue
        }
    }
    
    func countOfSentPhotos() -> Int {
        var countOfPhotos = 0
        
        if self.participantOne != nil {
            for photo in self.participantOne!.photos!.allObjects as! [Photo] {
                if photo.isSent {
                    countOfPhotos += 1
                }
            }
        }
        
        if self.participantTwo != nil {
            for photo in self.participantTwo!.photos!.allObjects as! [Photo] {
                if photo.isSent {
                    countOfPhotos += 1
                }
            }
        }
        
        if self.additionalPhotos != nil {
            for photo in self.additionalPhotos!.allObjects as! [Photo] {
                if photo.isSent {
                    countOfPhotos += 1
                }
            }
        }
        
        return countOfPhotos
    }
    
    func countOfAllPhotos() -> Int {
        var countOfPhotos = 0
        
        if self.participantOne != nil {
            if self.participantOne!.photos != nil {
                countOfPhotos += self.participantOne!.photos!.count
            }
        }
        
        if self.participantTwo != nil {
            if self.participantTwo!.photos != nil {
                countOfPhotos += self.participantTwo!.photos!.count
            }
        }
        
        if self.additionalPhotos != nil {
            countOfPhotos += self.additionalPhotos!.count
        }
        
        return countOfPhotos
    }
    
    func countOfAccidentPhotos() -> Int {
        var countOfPhotos = 0
        
        if self.participantOne != nil {
            for photo in self.participantOne!.photos!.allObjects as! [Photo] {
                if photo.typeValue > 4 {
                    countOfPhotos += 1
                }
            }
        }
        
        if self.participantTwo != nil {
            for photo in self.participantTwo!.photos!.allObjects as! [Photo] {
                if photo.typeValue > 4 {
                    countOfPhotos += 1
                }
            }
        }
        
        if self.additionalPhotos != nil {
            countOfPhotos += self.additionalPhotos!.count
        }
        
        return countOfPhotos
    }
    
    public override func awakeFromInsert() {
        self.state = .editing
    }
    
    public func getUnsentPhoto() -> Photo? {
        if self.participantOne != nil {
            for photo in self.participantOne!.photos!.allObjects as! [Photo] {
                if photo.isSent == false {
                    return photo
                }
            }
        }
        
        if self.participantTwo != nil {
            for photo in self.participantTwo!.photos!.allObjects as! [Photo] {
                if photo.isSent == false {
                    return photo
                }
            }
        }
        
        if self.additionalPhotos != nil {
            for photo in self.additionalPhotos!.allObjects as! [Photo] {
                if photo.isSent == false {
                    return photo
                }
            }
        }
        
        return nil
    }
    
    public func deletePhoto(with index: Int){
        if index < 9 {
            if self.participantOne != nil {
                for photo in self.participantOne!.photos!.allObjects as! [Photo] {
                    if photo.typeValue == index {
                        DataManager.deleteImageFromCash(pathName: "Images",
                                                        fileName: photo.fileName!)
                        PersistenceService.context.delete(photo)
                        return
                    }
                }
            }
        } else if index < 18 {
            if self.participantTwo != nil {
                for photo in self.participantTwo!.photos!.allObjects as! [Photo] {
                    if photo.typeValue == index {
                        DataManager.deleteImageFromCash(pathName: "Images",
                                                        fileName: photo.fileName!)
                        PersistenceService.context.delete(photo)
                        return
                    }
                }
            }
        } else {
            if self.additionalPhotos != nil {
                for photo in self.additionalPhotos!.allObjects as! [Photo] {
                    if photo.typeValue == index {
                        DataManager.deleteImageFromCash(pathName: "Images",
                                                        fileName: photo.fileName!)
                        PersistenceService.context.delete(photo)
                        return
                    }
                }
            }
        }
    }
}
