
import Foundation
import SwiftyJSON

public enum Requests: Request {
    case sendForChecking(
        accident: Accident,
        deviceId: String,
        tokenFCM: String
    )
    
    //id > 0, gibdd_response
    case sendImage(
        accidentRegisterId: Int,
        photoNumber: Int,
        imageEncoded: String
    )
    
    //result = 1
    case sendTwoSms(
        phoneA: String,
        phoneB: String
    )
    
    case geocode(
        longitude: String,
        latitude: String
    )
    
    case fixProtocol(
        accident: Accident,
        codeA: String,
        codeB: String
    )
    
    
    public var path: String {
        switch self {
        case .sendTwoSms, .geocode, .sendForChecking, .sendImage, .fixProtocol:
            return "/"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .sendTwoSms, .geocode, .sendForChecking, .fixProtocol:
            return .get
        case .sendImage:
            return .post
        }
    }
    
    public var parameters: RequestParams {
        switch self {
        case .sendTwoSms(let phoneA, let phoneB):
            return .url(["action": "send_two_sms", "a_phone" : phoneA, "b_phone" : phoneB])
            
        case .geocode(let longitude, let latitude):
            var toGeocode = longitude
            toGeocode.append(",")
            toGeocode.append(latitude)
            return .url(["format": "json", "results": "1", "geocode": toGeocode])
            
        case .sendForChecking(let accident, let deviceId, let tokenFCM):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.YYYY HH:mm"
            let dateTime = Date(timeIntervalSince1970: accident.dateTime!.timeIntervalSince1970)
            let jsonProtocol : JSON = [
                "date_dtp" : dateFormatter.string(from: dateTime),
                "mesto_dtp" : accident.place!.placeFull!,
                "mesto_dtp_lat" : accident.place!.latitude,
                "mesto_dtp_lon" : accident.place!.longitude,
                
                "a_phone" : "+7" + accident.participantOne!.driversPhone!,
                "a_dtp_type": accident.participantOne!.stateValue,
                "b_dtp_type": accident.participantTwo!.stateValue,
                "id_server": accident.registerId,
                "b_phone" : "+7" + accident.participantTwo!.driversPhone!
            ]
            let stringProtocol =
                jsonProtocol.rawString(String.Encoding.utf8, options: [.prettyPrinted])!.percentEscapeString()
            return .url(["action": "for_checking",
                          "type_check": "1",
                          "DeviceID": deviceId,
                          "TokenFCM": tokenFCM,
                          "protocol": stringProtocol])
            
        case .sendImage(let accidentRegisterId, let photoNumber, let imageEncoded):
            return .body(["id": String(accidentRegisterId),
                          "photonum": String(photoNumber),
                          "image": imageEncoded])
            
        case .fixProtocol(let accident, let codeA, let codeB):
            let jsonProtocol : JSON = [
                "id_server": accident.registerId,
                "a_phone": accident.participantOne!.driversPhone!,
                "b_phone": accident.participantTwo!.driversPhone!,
                "a_sms_code": codeA,
                "b_sms_code": codeB
            ]
            let stringProtocol =
                jsonProtocol.rawString(String.Encoding.utf8, options: [.prettyPrinted])!.percentEscapeString()
            return .url(["protocol": stringProtocol])
        }
    }
    
    public var headers: [String : Any]? {
        return [:]
    }
    
    public var dataType: DataType {
        return .Data
    }
}
