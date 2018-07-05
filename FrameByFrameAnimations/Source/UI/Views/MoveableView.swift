//
//  MoveableView.swift
//  FrameByFrameAnimations
//
//  Created by Seth on 8/10/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import UIKit

class MoveableView: UIView, RandomMoveable {
    
    // variables for tracking views movement
    internal var acceleration: CGPoint = .zero
    internal var velocity: CGPoint = .zero
    
    // tracking for animation time limit
    internal var timeLimit: CGFloat = 1.0
    internal var currentTime: CGFloat = 0.0
    
    // flags for managing view reuse
    var canAnimate: Bool = true
    var isReadyForReuse: Bool = false
    
    /// Resets view variables to default values and updates the center to a new center location passed in by caller. Calling this prepares this view to be reused for a new animation.
    ///
    /// - Parameter center: The center point for this view. This will be the location where this view will appear once it is added to a superview.
    func reset(center: CGPoint = .zero) {
        
        // don't reset until the transform animation has finished
        guard isReadyForReuse == true else {
            return
        }
        
        // reset variables
        self.center = center
        self.currentTime = 0.0
        
        // setup a new diameter/size/alpha and reset the transform to original
        let diameter = CGFloat.random(low: 25.0, high: 40.0)
        frame = CGRect.init(x: CGFloat(0.0), y: CGFloat(0.0), width: diameter, height: diameter)
        alpha = CGFloat.random(low: 0.1, high: 1.0)
        transform = .identity
        
        // update the new center value
        self.center = center
        
        // set new tint color if desired
        tintColor = .blue
        
        // update velocity/acceleration/time to new value
        configureMovement()
        
        // reset flags
        self.isReadyForReuse = false
        self.canAnimate = true
    }
    
    
    /// sets or resets velocity/acceleration & time limit
    internal func configureMovement() {
        
        // define the limits for our random numbers that define the velocity & acceleration values for animating onscreen.
        let low: CGFloat = -100.0
        let high: CGFloat = 100.0
        
        // define the values by which our center will be updated with each pass of the update call
        velocity = CGPoint.init(x: CGFloat.random(low: low, high: high), y: CGFloat.random(low: low, high: high))
        
        // define the values by which our velocity will change with each pass of the update call
        acceleration = CGPoint.init(x: CGFloat.random(low: low, high: high), y: CGFloat.random(low: low, high: high))
        
        // our time limit for each animation will be between 0.3 and 1.5 seconds
        let limit = CGFloat.random(low: 0.3, high: 1.5)
        timeLimit = limit
    }
    
    
    /// When called this view calculates a new center position and updates its center property to this new value
    ///
    /// - Parameter deltaTime: Passed in from our display link wrapper. Represents the framerate by which we calculate a new position for smooth movement. The hard value is the difference in time between the last frame timestamp and the current frame timestamp. At 60 frames/second this value is ~0.01666.
    /// - Returns: Returns true if the update was performed successfully, else false. (False means either we ran past our animation time limit or this view has been flagged for recycling/reuse)
    @discardableResult
    func update(deltaTime: CFTimeInterval) -> Bool {
        
        // validate
        guard canAnimate == true, isReadyForReuse == false else {
            return false
        }
        
        // by multiplying our x/y values by the delta time new values are generated that will generate a smooth animation independent of the framerate.
        let smoothVel = CGPoint(x: CGFloat(Double(velocity.x)*deltaTime), y: CGFloat(Double(velocity.y)*deltaTime))
        let smoothAccel = CGPoint(x: CGFloat(Double(acceleration.x)*deltaTime), y: CGFloat(Double(acceleration.y)*deltaTime))
        
        // update velocity with smoothed acceleration
        velocity.adding(point: smoothAccel)
        
        // update center with smoothed velocity
        center.adding(point: smoothVel)
        
        // take the superview bounds and add padding the width of our animateable view
        // so it can travel completely offscreen before being removed from the view, if
        // you want it to 'bounce' off the edges of the screen remove the 'adding(padding:)
        // call below
        let isVisible = superview?.bounds.adding(padding: bounds.width).contains(frame)
        
        currentTime += 0.01
        if currentTime >= timeLimit || isVisible == false {
            canAnimate = false
            endAnimation()
            return false
        }
        
        return true
    }
    
    /// Performs a small scale transform then removes from superview and flags as ready for reuse so it will not receive update notifications. Called by update(:) when the animation has run past it's time limit.
    func endAnimation() {
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { [weak self] (finished) in
            self?.removeFromSuperview()
            self?.isReadyForReuse = true
        }
    }
}
