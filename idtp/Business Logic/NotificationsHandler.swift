//
//  NotificationsHandler.swift
//  idtp
//
//  Created by Apple on 30.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

class NotificationsHandler {
    
    var editingAccident: Accident?
    
    func handleMessage(msgType : Int,
                       msgTitle: String,
                       msgBody: String,
                       msgValues: String?,
                       msgExtra : String) {
        
        editingAccident = AccidentService.getEditingAccident()
        
//        if msgType == 1 {
        
        handleSuccessNotification(msgBody: msgBody)

//        } else if msgType == 2 {
//
//            handleRemakeAccidentNotification(msgValues: msgValues, msgExtra: msgExtra)
//        }
        
        NotificationCenter.default.post(name: .notificationProcessed, object: nil)
    }
    
    func handleSuccessNotification(msgBody: String) {
        editingAccident?.state = .confirming
        editingAccident?.gibddResponce = msgBody
    }
    
//    func handleRemakeAccidentNotification(msgValues: String?,
//                                          msgExtra : String){
//        editingAccident?.state = .editing
//
//        var extra = msgExtra.components(separatedBy: ";")
//
//        let additionalPhotosCount = extra[0]
//        editingAccident?.additionalPhotosRequired = Int32(additionalPhotosCount)!
//
//        let photosToRemake = extra[1]
//        let photoTypeValuesToRemake = photosToRemake.components(separatedBy: ",")
//
//        for index in photoTypeValuesToRemake {
//            editingAccident?.deletePhoto(with: Int(index)!)
//        }
//    }
}
