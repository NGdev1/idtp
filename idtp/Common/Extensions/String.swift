//
//  String.swift
//  idtp
//
//  Created by Apple on 28.03.2018.
//  Copyright © 2018 md. All rights reserved.
//

import Foundation

extension String {
    func percentEscapeString() -> String {
        let result = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                             self as CFString!,
                                                             nil,
                                                             ":/?@!$&'()*+,;=" as CFString!,
                                                             CFStringBuiltInEncodings.UTF8.rawValue)
        return (result as! String)
    }
}

extension String {
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}
