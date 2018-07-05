//
//  File.swift
//  kidoodle
//
//  Created by Seth on 4/21/16.
//  Copyright © 2016 Arnott Industries Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    class func colorFromHex(_ rgb: Int, alpha: CGFloat) -> UIColor {
        let red = CGFloat(Float(((rgb>>16) & 0xFF)) / 255.0)
        let green = CGFloat(Float(((rgb>>8) & 0xFF)) / 255.0)
        let blue = CGFloat(Float(((rgb>>0) & 0xFF)) / 255.0)
        let alpha = CGFloat(alpha)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

}
