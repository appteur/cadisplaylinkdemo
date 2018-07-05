//
//  CGRectExtensions.swift
//  FrameByFrameAnimations
//
//  Created by Seth on 7/5/18.
//  Copyright © 2018 Seth. All rights reserved.
//

import UIKit

extension CGRect {
    func adding(padding: CGFloat) -> CGRect {
        // creates and returns a new rect that is larger than the original by the specified padding size
        return CGRect.init(
            x: origin.x - padding,
            y: origin.y - padding,
            width: width + (padding * 2),
            height: height + (padding * 2))
    }
    
    func subtracting(padding: CGFloat) -> CGRect {
        // creates and returns a new rect that is smaller than the original by the specified padding size
        return CGRect.init(
            x: origin.x + padding,
            y: origin.y + padding,
            width: width - (padding * 2),
            height: height - (padding * 2))
    }
}
