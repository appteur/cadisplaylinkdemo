//
//  MoveableView.swift
//  FrameByFrameAnimations
//
//  Created by Seth on 8/10/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import UIKit

class MoveableView: UIView, RandomMoveable {
    var acceleration: CGPoint = .zero
    var velocity: CGPoint = .zero
    
    var timeLimit: CGFloat = 1.0
    var currentTime: CGFloat = 0.0
    
    var canAnimate: Bool = true
    var isReadyForReuse: Bool = false
    
    func reset(center: CGPoint = .zero) {
        // don't reset until the 'pop' animation has finished
        guard isReadyForReuse == true else {
            return
        }
        
        // set vars
        self.center = center
        self.currentTime = 0.0
        
        // update imageview
        let diameter = CGFloat.random(low: 25.0, high: 40.0)
        frame = CGRect.init(x: CGFloat(0.0), y: CGFloat(0.0), width: diameter, height: diameter)
        alpha = CGFloat.random(low: 0.1, high: 1.0)
        transform = .identity
        self.center = center
        tintColor = .blue
        
        // update velocity/acceleration/time
        configureMovement()
        
        // reset flags
        self.isReadyForReuse = false
        self.canAnimate = true
    }
    
    
    /// sets or resets velocity/acceleration & time limit
    internal func configureMovement() {
        let low: CGFloat = -100.0
        let high: CGFloat = 100.0
        velocity = CGPoint.init(x: CGFloat.random(low: low, high: high), y: CGFloat.random(low: low, high: high))
        acceleration = CGPoint.init(x: CGFloat.random(low: low, high: high), y: CGFloat.random(low: low, high: high))
        let limit = CGFloat.random(low: 0.3, high: 1.5)
        timeLimit = limit
    }
    
    
    func update(deltaTime: CFTimeInterval) -> Bool {
        guard canAnimate == true, isReadyForReuse == false else {
            return false
        }
        
        let smoothVel = CGPoint(x: CGFloat(Double(velocity.x)*deltaTime), y: CGFloat(Double(velocity.y)*deltaTime))
        let smoothAccel = CGPoint(x: CGFloat(Double(acceleration.x)*deltaTime), y: CGFloat(Double(acceleration.y)*deltaTime))
        
        // update velocity with smoothed acceleration
        velocity.adding(point: smoothAccel)
        
        // update center with smoothed velocity
        center.adding(point: smoothVel)
        
        currentTime += 0.01
        if currentTime >= timeLimit {
            canAnimate = false
            endAnimation()
            return false
        }
        
        return true
    }
    
    func endAnimation() {
        UIView.animate(withDuration: 0.1, animations: { [weak self] _ in
            self?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
            self?.isReadyForReuse = true
        }
    }
}
