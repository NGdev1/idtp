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
    
    func setPhotoWith(typeValue : Int, image: UIImage) {
        
        self.deletePhoto(with: typeValue)
        
        let photo = PhotoService.createPhoto()
        self.addToPhotos(photo)
        
        let fileName = String(NSUUID().uuidString + ".jpeg")
        let imageData = UIImageJPEGRepresentation(image, 1.0)!
        
        DataManager.saveImageToCash(pathName: "Images",
                                    fileName: fileName,
                                    data: imageData,
                                    maxWidth: 512)
        
        photo.fileName = fileName
        photo.typeValue = Int32(typeValue)
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
            print(photo.fileName ?? "")
        }
    }
    
    func countOfSentPhotos() -> Int {
        var countOfPhotos = 0
        
        if self.photos != nil {
            for photo in self.photos!.allObjects as! [Photo] {
                if photo.isSent {
                    countOfPhotos += 1
                }
            }
        }
        
        return countOfPhotos
    }
    
    func countOfAccidentPhotos() -> Int {
        var countOfPhotos = 0
        
        if self.photos != nil {
            for photo in self.photos!.allObjects as! [Photo] {
                if photo.typeValue > 9 {
                    countOfPhotos += 1
                }
            }
        }
        
        return countOfPhotos
    }
    
    func countOfAllPhotos() -> Int {
        guard let photos = self.photos else {
            return 0
        }
        
        return photos.count
    }
    
    public override func awakeFromInsert() {
        self.state = .editing
    }
    
    public func getUnsentPhoto() -> Photo? {
        
        if self.photos != nil {
            for photo in self.photos!.allObjects as! [Photo] {
                if photo.isSent == false {
                    return photo
                }
            }
        }
        
        return nil
    }
    
    public func deletePhoto(with typeValue: Int){
        
        if let photo = getPhotoWith(typeValue: typeValue) {
            DataManager.deleteImageFromCash(pathName: "Images",
                                            fileName: photo.fileName!)
            PersistenceService.context.delete(photo)
        }
    }
}
