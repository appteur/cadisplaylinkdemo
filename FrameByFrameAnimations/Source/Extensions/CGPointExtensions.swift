//
//  extension_CGPoint.swift
//  FrameByFrameAnimations
//
//  Created by Seth on 8/10/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import UIKit

extension CGPoint {
    mutating func adding(point: CGPoint) {
        x += point.x
        y += point.y
    }
    
    mutating func subtracting(point: CGPoint) {
        x -= point.x
        y -= point.y
    }
}
