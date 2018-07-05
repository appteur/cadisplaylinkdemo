//
//  ViewController.swift
//  FrameByFrameAnimations
//
//  Created by Seth on 8/10/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import UIKit

class ViewController: UIViewController, DisplayUpdateReceiver {

    var displayLinker: DisplayUpdateNotifier?
    var animView: MoveableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animView = MoveableView.init(frame: CGRect.init(x: 150.0, y: 400.0, width: 20.0, height: 20.0))
        animView?.configureMovement()
        animView?.backgroundColor = .blue
        view.addSubview(animView!)
        
        displayLinker = DisplayUpdateNotifier.init(listener: self)
    }

    func displayWillUpdate(deltaTime: CFTimeInterval) {
        
        animView?.update(deltaTime: deltaTime)
        
        if animView?.isReadyForReuse == true {
            animView?.reset(center: CGPoint.init(x: CGFloat.random(low: 20.0, high: 300.0), y: CGFloat.random(low: 20.0, high: 700.0)))
            view.addSubview(animView!)
        }
    }

}

