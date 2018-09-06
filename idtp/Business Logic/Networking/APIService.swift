
import UIKit
import SwiftyJSON

protocol APIServiceSharier {
    var sharedAPIService: APIService {get}
}

class APIService: NSObject {
    
    public static let baseURLServer = "http://178.206.224.220/evroprotocol/api/"
    public static let baseURLYandexGeocoding = "https://geocode-maps.yandex.ru/1.x"
    //public static let accessKey = ""
    
    private let environmentMain: NetworkingEnvironment
    private let dispatcherMain: NetworkingDispatcher
    
    private let environmentYandexGeocoding: NetworkingEnvironment
    private let dispatcherYandexGeocoding: NetworkingDispatcher
    
    static func shared() -> APIService {
        return (UIApplication.shared.delegate as! APIServiceSharier).sharedAPIService
    }
    
    override init() {
        environmentMain = NetworkingEnvironment("main", host: APIService.baseURLServer)
        dispatcherMain = ConcreateNetworkingDispatcher(environment: environmentMain)
        
        environmentYandexGeocoding = NetworkingEnvironment("yandexGeociding", host: APIService.baseURLYandexGeocoding)
        dispatcherYandexGeocoding = ConcreateNetworkingDispatcher(environment: environmentYandexGeocoding)
    }
    
    public func sendTwoSms(phoneA: String, phoneB : String, completionHandler: @escaping(Int?, Error?) -> Void) -> URLSessionDataTask {
        let operation = SendTwoSmsOperation(phoneA: phoneA, phoneB: phoneB)
        
        return operation.execute(in: dispatcherMain, completionHandler: completionHandler)
    }
    
    public func geocode(longitude: String, latitude : String, completionHandler: @escaping ((addressName: String?, fullAddress: String?)?, Error?) -> Void) ->URLSessionDataTask {
        let operation = GeocodeOperation(longitude: longitude, latitude: latitude)
        
        return operation.execute(in: dispatcherYandexGeocoding, completionHandler: completionHandler)
    }
    
    public func sendImage(accidentRegisterId: Int, photo: Photo, completionHandler: @escaping (Int?, Error?) -> Void) -> URLSessionDataTask {
        let imageData = DataManager.getDataFromCash(pathName: "Images", fileName: photo.fileName!)
        let strBase64: String = imageData!.base64EncodedString()
        
        let operation = SendImageOperation(accidentRegisterId: accidentRegisterId,
                                           photoNumber: Int(photo.typeValue),
                                           imageEncoded: strBase64)
        
        return operation.execute(in: dispatcherMain, completionHandler: completionHandler)
    }
    
    public func sendForChecking(accident: Accident, deviceId: String, tokenFCM: String, completionHandler: @escaping ((code: Int?, gibddResponce: String?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = SendForCheckingOperation(accident: accident, deviceId: deviceId, tokenFCM: tokenFCM)
        
        return operation.execute(in: dispatcherMain, completionHandler: completionHandler)
    }
    
    public func fixProtocol(accident: Accident, codeA: String, codeB: String, completionHandler: @escaping ((code: Int?, gibddResponce: String?)?, Error?) -> Void) -> URLSessionDataTask {
        let operation = FixProtocolOperation(accident: accident, codeA: codeA, codeB: codeB)
        
        return operation.execute(in: dispatcherMain, completionHandler: completionHandler)
    }
}
