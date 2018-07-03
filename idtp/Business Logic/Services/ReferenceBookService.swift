//
//  ReferenceBookService.swift
//  idtp
//
//  Created by Apple on 05.04.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation
import SwiftyJSON

class ReferenceBookService {
    
    private static func toAttributtedString(data: Data) -> NSAttributedString {
        let htmlString = String(data: data, encoding: String.Encoding.utf8)!
        return toAttributedString(htmlString: htmlString)
    }
    
    private static func toAttributedString(htmlString: String) -> NSAttributedString {
        
        let htmlData = NSString(string: htmlString).data(using: String.Encoding.unicode.rawValue)
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        
        let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
        
        return attributedString
    }
    
    static func loadAttributedString(fileName: String) -> NSAttributedString {
        guard let data = DataManager.getDataFromResource(fileName: fileName) else {
            return NSAttributedString()
        }
        
        return toAttributtedString(data: data)
    }
    
    static func loadAboutText() -> NSAttributedString {
        return loadAttributedString(fileName: "about.html")
    }
    
    static func loadKoapText() -> NSAttributedString {
        return loadAttributedString(fileName: "koap.html")
    }
    
    static func loadDtpFaqText() -> NSAttributedString {
        return loadAttributedString(fileName: "dtp_faq.html")
    }
    
    static func loadRegionCodes() -> NSAttributedString {
        return loadAttributedString(fileName: "kodi_regions.html")
    }
    
    static func loadGibddPhoneNumbers() -> NSAttributedString {
        return loadAttributedString(fileName: "tel_gibdd.html")
    }
    
    static func loadPddItems() -> [PddItem]? {
        guard let data = DataManager.getDataFromResource(fileName: "PddRulesList.json") else {
            return nil
        }
        
        var result = [PddItem]()
        
        do {
            let json = try JSON(data: data)

            for item in json["pdd"].arrayValue {
                
                let name = item["name"].stringValue
                let content = loadAttributedString(fileName: item["fileName"].stringValue)
                
                result.append(PddItem(
                    name: name,
                    content: content)
                )
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        return result
    }
}
