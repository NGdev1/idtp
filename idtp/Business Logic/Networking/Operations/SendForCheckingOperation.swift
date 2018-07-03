//
//  SendForCheckingOperation.swift
//  idtp
//
//  Created by Apple on 23.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import SwiftyJSON

class SendForCheckingOperation: NetworkingOperation {
    
    var request: Request
    
    init(accident: Accident, deviceId: String, tokenFCM: String) {
        request = Requests.sendForChecking(accident: accident,
                                           deviceId: deviceId,
                                           tokenFCM: tokenFCM)
    }
    
    typealias Result = (code: Int?, gibddResponce: String?)?
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping ((code: Int?, gibddResponce: String?)?, Error?) -> Void) -> URLSessionDataTask {
        
        return dispatcher.execute(request: request,
                                  completionHandler: { (data, response, error) in
            if let err = error {
                completionHandler(nil, err)
                return
            } else {
                if response?.statusCode != 200 || data == nil {
                    completionHandler(nil, APIErrors.unknounError)
                } else {
                    let json = try! JSON(data: data!)
                    
                    let gibddResponce = json["gibdd_response"].string
                    let code = json["id"].intValue
                    
                    completionHandler((code, gibddResponce), nil)
                }
            }
        })
    }
    
}
