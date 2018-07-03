//
//  ColorHelper.swift
//  Mouse
//
//  Created by Amir Zigangarayev on 09.11.2017.
//  Copyright © 2017 Mouse. All rights reserved.
//

import UIKit

class ColorHelper {
    
    enum ColorName {
        case baseTintColor
    }
    
    static func color(for name: ColorName) -> UIColor {
        switch name {
        case .baseTintColor:
            return #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }
}
