//
//  GeocodeOperation.swift
//  idtp
//
//  Created by Apple on 20.02.2018.
//  Copyright © 2018 md. All rights reserved.
//

import UIKit
import SwiftyJSON

class GeocodeOperation: NetworkingOperation {
    
    var request: Request
    
    init(longitude: String, latitude : String) {
        request = Requests.geocode(longitude: longitude, latitude: latitude)
    }
    
    typealias Result = (addressName: String?, fullAddress: String?)?
    func execute(in dispatcher: NetworkingDispatcher, completionHandler: @escaping ((addressName: String?, fullAddress: String?)?, Error?) -> Void) -> URLSessionDataTask {
        
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
                    
                    let addressName = json["response", "GeoObjectCollection", "featureMember", 0, "GeoObject", "name"].string
                    let fullAddress = json["response", "GeoObjectCollection", "featureMember", 0, "GeoObject", "metaDataProperty", "GeocoderMetaData", "Address", "formatted"].string
                    
                    
                    completionHandler((addressName, fullAddress), nil)
                }
            }
        })
    }
    
}
