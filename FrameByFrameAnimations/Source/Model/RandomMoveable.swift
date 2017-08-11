//
//  RandomAnimation.swift
//  Animation_Bubbles
//
//  Created by Seth on 7/5/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import UIKit


/// Defines an interface for an object that manages it's movement when receiving update calls.
protocol RandomMoveable {
    var center: CGPoint { get set }
    var velocity: CGPoint { get set }
    var acceleration: CGPoint { get set }
    
    var timeLimit: CGFloat { get set }
    var currentTime: CGFloat { get set }
    
    var canAnimate: Bool { get set }
    var isReadyForReuse: Bool { get set }
    
    func update(deltaTime: CFTimeInterval) -> Bool
    func endAnimation()
}

extension RandomMoveable where Self: UIView {
    
    /// Default implementation of update function for UIViews conforming to the RandomMoveable protocol.
    ///
    /// - Parameter deltaTime: The difference in time between the last display update call and the current call
    /// - Returns: Returns true if update is successful, else false.
    mutating func update(deltaTime: CFTimeInterval) -> Bool {
        guard canAnimate == true, isReadyForReuse == false else {
            return false
        }
        
        center.x += CGFloat(Double(velocity.x)*deltaTime)
        center.y += CGFloat(Double(velocity.y)*deltaTime)
        
        velocity.x += acceleration.x
        velocity.y += acceleration.y
        
        currentTime += 0.01
        if currentTime >= timeLimit {
            canAnimate = false
            endAnimation()
            return false
        }
        
        return true
    }
    
    
    /// Default implementation to end an animation when it's time expires.
    mutating func endAnimation() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] _ in
            self?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
            self?.isReadyForReuse = true
        }
    }
}
