//
//  DisplayUpdateNotifier.swift
//  FrameByFrameAnimations
//
//  Created by Seth on 8/10/17.
//  Copyright © 2017 Seth. All rights reserved.
//

import UIKit

class DisplayUpdateNotifier {
    
    // **********************************************
    //  MARK: Variables
    // **********************************************
    
    /// A weak reference to the delegate/listener that will be notified/called on display updates
    weak var listener: DisplayUpdateReceiver?
    
    /// The display link that will be initiating our updates
    internal var displayLink: CADisplayLink? = nil
    
    /// Tracks the timestamp from the previous displayLink call
    internal var lastTime: CFTimeInterval = 0.0
    
    // **********************************************
    //  MARK: Setup & Tear Down
    // **********************************************
    
    deinit {
        stopDisplayLink()
    }
    
    init(listener: DisplayUpdateReceiver) {
        // setup our delegate listener reference
        self.listener = listener
        
        // setup & kick off the display link
        startDisplayLink()
    }
    
    // **********************************************
    //  MARK: CADisplay Link
    // **********************************************
    
    /// Creates a new display link if one is not already running
    private func startDisplayLink() {
        guard displayLink == nil else {
            return
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(linkUpdate))
        displayLink?.add(to: .main, forMode: .commonModes)
        lastTime = 0.0
    }
    
    /// Invalidates and destroys the current display link. Resets timestamp var to zero
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
        lastTime = 0.0
    }
    
    /// Notifier function called by display link. Calculates the delta time and passes it in the delegate call.
    @objc private func linkUpdate() {
        // bail if our display link is no longer valid
        guard let displayLink = displayLink else {
            return
        }
        
        // get the current time
        let currentTime = displayLink.timestamp
        
        // calculate delta (
        let delta: CFTimeInterval = currentTime - lastTime
        
        // store as previous
        lastTime = currentTime
        
        // call delegate
        listener?.displayWillUpdate(deltaTime: delta)
    }
}

