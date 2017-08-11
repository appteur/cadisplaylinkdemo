//
//  File.swift
//  kidoodle
//
//  Created by Seth on 4/22/16.
//  Copyright © 2016 Arnott Industries Inc. All rights reserved.
//

import UIKit


extension UIView
{
    /**
        Captures the layer of just this view and renders to image.
     */
    func snapshotImage()->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return copied!
    }
    
    /**
        Captures view and subviews in an image
     */
    func snapshotViewHierarchy()->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let copied = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return copied!
    }
    
    /**
        Captures and returns full view hierarchy as png data
     */
    func snapshotData() -> Data?
    {
        let pngData = UIImagePNGRepresentation(self.snapshotViewHierarchy())
        return pngData
    }
}
