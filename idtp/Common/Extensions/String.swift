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
