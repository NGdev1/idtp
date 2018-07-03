//
//  ParticipantService.swift
//  idtp
//
//  Created by Apple on 21.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import CoreData

class ParticipantService{
    static func createParticipant() -> Participant {
        return Participant(entity: Participant.entity(),
                           insertInto: PersistenceService.context)
    }
}
