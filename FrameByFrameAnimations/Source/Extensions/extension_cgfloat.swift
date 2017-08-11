//
//  extension_cgfloat.swift
//  kidoodle
//
//  Created by Seth on 7/5/17.
//  Copyright © 2017 Arnott Industries Inc. All rights reserved.
//

import UIKit

extension CGFloat {
    
    static func random(low: CGFloat, high: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * Swift.abs(low - high) + CGFloat.minimum(low, high)
    }
}

extension Int {
    
    static func random(range: Range<Int>) -> Int {
        // arc4random_uniform(_: UInt32) returns UInt32, so it needs explicit type conversion to Int
        // note that the random number is unsigned so we don't have to worry that the modulo
        // operation can have a negative output
        return  Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))) + range.lowerBound
    }
    
    
}
