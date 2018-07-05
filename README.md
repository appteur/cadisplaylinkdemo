# Animations with CADisplayLink

## Description

This is a sample project demonstrating how to create smooth animations using CADisplayLink in iOS projects. 

This project uses a wrapper class to encapsulate CADisplayLink and fires a delegate function call with the delta time between the last display frame timestamp and the current display timestamp. This allows the movement of your object to update smoothly independently of the framerate.


## Overview

This implementation wraps the display link in it's own class and sets up a delegate reference that will get called with the delta time (the time between the last display link call and the current call) so animations can be performed more smoothly.

I'm currently using this method to animate ~60 views around the screen simultaneously in a game.

First define the delegate protocol that the wrapper will call to notify of update events.
```Swift

// defines an interface for receiving display update notifications
protocol DisplayUpdateReceiver: class {
    func displayWillUpdate(deltaTime: CFTimeInterval)
}

```

Next define the display link wrapper class. This class will take a delegate reference on initialization. When initialized it will automatically start the display link and clean it up on deinit.

```Swift

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

```

To use it simply initialize an instance of the wrapper, passing in the delegate listener reference, then update your animations based on the delta time. 

In this example, the delegate passes the update call off to the animatable view (this way you could track multiple animating views and have each update their positions via this call).

```Swift

class ViewController: UIViewController, DisplayUpdateReceiver {

    var displayLinker: DisplayUpdateNotifier?
    var animView: MoveableView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // setup our animatable view and add as subview
        animView = MoveableView.init(frame: CGRect.init(x: 150.0, y: 400.0, width: 20.0, height: 20.0))
        animView?.configureMovement()
        animView?.backgroundColor = .blue
        view.addSubview(animView!)

        // setup our display link notifier wrapper class
        displayLinker = DisplayUpdateNotifier.init(listener: self)
    }

    // implement DisplayUpdateReceiver function to receive updates from display link wrapper class
    func displayWillUpdate(deltaTime: CFTimeInterval) {
        // pass the update call off to our animating view or views
        _ = animView?.update(deltaTime: deltaTime)

        // in this example, the animatable view will remove itself from its superview when its animation is complete and set a flag
        // that it's ready to be used. We simply check if it's ready to be recycled, if so we reset its position and add it to
        // our view again
        if animView?.isReadyForReuse == true {
            animView?.reset(center: CGPoint.init(x: CGFloat.random(low: 20.0, high: 300.0), y: CGFloat.random(low: 20.0, high: 700.0)))
            view.addSubview(animView!)
        }
    }
}

```

Our moveable views update function looks like this:

```Swift

func update(deltaTime: CFTimeInterval) -> Bool {
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

    currentTime += 0.01
    if currentTime >= timeLimit {
        canAnimate = false
        endAnimation()
        return false
    }

    return true
}

```

## Author

Seth Arnott

## License

This sample project is available under the MIT license.
