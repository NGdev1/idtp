//
//  FixProtocolOperation.swift
//  idtp
//
//  Created by Apple on 26.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class FixProtocolOperation: NetworkingOperation {
    
    var request: Request
    
    init(accident: Accident,
         codeA: String,
         codeB: String) {
        request = Requests.fixProtocol(accident: accident, codeA: codeA, codeB: codeB)
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
                    
                    let code = json["id"].intValue
                    let gibddResponce = json["gibdd_response"].string
                    
                    completionHandler((code, gibddResponce), nil)
                }
            }
        })
    }
}
