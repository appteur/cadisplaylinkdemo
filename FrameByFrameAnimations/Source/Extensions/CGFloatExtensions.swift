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
