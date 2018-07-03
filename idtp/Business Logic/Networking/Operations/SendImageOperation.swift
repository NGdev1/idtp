//
//  SendImageOperation.swift
//  idtp
//
//  Created by Apple on 26.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class SendImageOperation: NetworkingOperation {
    
    var request: Request
    
    init(accidentRegisterId: Int,
         photoNumber: Int,
         imageEncoded: String) {
        
        request = Requests.sendImage(accidentRegisterId: accidentRegisterId,
                                     photoNumber: photoNumber,
                                     imageEncoded: imageEncoded)
    }
    
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping (Int?, Error?) -> Void) -> URLSessionDataTask {
        return dispatcher.execute(request: request,
                                  completionHandler: { (data, response, error) in
            if let err = error {
                completionHandler(nil, err)
                return
            } else {
                if response?.statusCode != 200 || data == nil {
                    completionHandler(nil, APIErrors.unknounError)
                } else {
                    do {
                        let json = try JSON(data: data!)
                        
                        let code = json["id"].intValue
                        
                        completionHandler(code, nil)
                    } catch {
                        completionHandler(nil, APIErrors.unknounError)
                    }
                }
            }
        })
    }
}
