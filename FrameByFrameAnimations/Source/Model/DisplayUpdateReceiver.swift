//
//  File.swift
//  FrameByFrameAnimations
//
//  Created by Seth on 8/10/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import UIKit

/// Defines an interface an object must implement to receive notifications when the display is about to update.
protocol DisplayUpdateReceiver: class {
    
    /// Called when the display is about to update.
    ///
    /// - Parameter deltaTime: The difference in time between the last update call and the current call. Representative of framerate.
    func displayWillUpdate(deltaTime: CFTimeInterval)
}
