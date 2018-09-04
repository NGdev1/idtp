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
}
