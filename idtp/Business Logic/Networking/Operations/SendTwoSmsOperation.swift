
import UIKit
import SwiftyJSON

class SendTwoSmsOperation: NetworkingOperation {
    
    var request: Request
    
    init(phoneA : String, phoneB: String) {
        request = Requests.sendTwoSms(phoneA: phoneA, phoneB: phoneB)
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
                                                
                                                let code = json["result"].intValue
                                                
                                                completionHandler(code, nil)
                                            }  catch {
                                                completionHandler(nil, APIErrors.unknounError)
                                            }
                                        }
                                    }
        })
    }
    
}
