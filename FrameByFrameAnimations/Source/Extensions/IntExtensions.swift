//
//  IntExtensions.swift
//  FrameByFrameAnimations
//
//  Created by Seth on 7/5/18.
//  Copyright © 2018 Seth. All rights reserved.
//

import Foundation

extension Int {
    
    static func random(range: Range<Int>) -> Int {
        // arc4random_uniform(_: UInt32) returns UInt32, so it needs explicit type conversion to Int
        // note that the random number is unsigned so we don't have to worry that the modulo
        // operation can have a negative output
        return  Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound))) + range.lowerBound
    }
}
