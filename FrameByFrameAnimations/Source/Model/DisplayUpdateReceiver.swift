//
//  File.swift
//  FrameByFrameAnimations
//
//  Created by Seth on 8/10/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import UIKit

protocol DisplayUpdateReceiver: class {
    func displayWillUpdate(deltaTime: CFTimeInterval)
}
