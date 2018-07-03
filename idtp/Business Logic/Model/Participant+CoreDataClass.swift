//
//  Participant+CoreDataClass.swift
//  idtp
//
//  Created by Apple on 19.02.2018.
//  Copyright © 2018 md. All rights reserved.
//
//

import Foundation
import CoreData

enum ParticipantState : Int32 {
    case injured        = 0
    case culprit        = 1
}


@objc(Participant)
public class Participant: NSManagedObject {
    var state : ParticipantState {
        get {
            return ParticipantState(rawValue: self.stateValue)!
        }
        
        set {
            self.stateValue = newValue.rawValue
        }
    }
    
    func setPhotoWith(typeValue : Int, image: UIImage) {
        var photo = getPhotoWith(typeValue: typeValue)
        
        if photo != nil {
            DataManager.deleteImageFromCash(pathName: "Images",
                                            fileName: photo!.fileName!)
            PersistenceService.context.delete(photo!)
        }
        
        photo = PhotoService.createPhoto()
        self.addToPhotos(photo!)
        
        let fileName = String(NSUUID().uuidString + ".jpeg")
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        
        DataManager.saveImageToCash(pathName: "Images",
                                    fileName: fileName,
                                    data: imageData,
                                    maxWidth: 512)
        
        photo!.fileName = fileName
        photo!.typeValue = Int32(typeValue)
        PersistenceService.saveContext()
    }
    
    func getPhotoWith(typeValue : Int) -> Photo? {
        
        guard self.photos != nil else {
            return nil
        }
        
        for photoItem in self.photos! {
            let photo = photoItem as! Photo
            if photo.typeValue == typeValue {
                return photo
            }
        }
        
        return nil
    }
    
    func printPhotos() {
        guard self.photos != nil else {
            return
        }
        
        for photoItem in self.photos! {
            let photo = photoItem as! Photo
            print(photo.fileName)
        }
    }
}
