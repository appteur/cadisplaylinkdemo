//
//  extension_uiviewcontroller.swift
//  drawmoji
//
//  Created by Seth on 9/14/16.
//  Copyright © 2016 Arnott Industries, Inc. All rights reserved.
//

import Foundation
import  UIKit

extension UIViewController
{
    func actionDismiss(sender:AnyObject?)
    {
        if self.navigationController != nil
        {
            if navigationController?.presentingViewController != nil, navigationController?.viewControllers.count == 1
            {
                navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            else
            {
                let _ = navigationController?.popViewController(animated: true)
            }
        }
        else if presentingViewController != nil
        {
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    
    // MARK: View Controller Containment convenience functions
    
    func addChild(child:UIViewController, toView: UIView, frame:CGRect, animationDuration:TimeInterval = 0.3, index:Int? = nil)
    {
        // notify child of containment
        child.willMove(toParentViewController: self)
        
        // add content as child
        self.addChildViewController(child)
        
        // set frame of child content
        child.view.frame = frame
        
        // alpha to 0 if we're animating in
        if animationDuration > 0 {
            child.view.alpha = 0.0
        }
        
        // add childs view to hierarchy pass - number for addSubview
        if let index = index, index > 0, index <= toView.subviews.count {
            toView.insertSubview(child.view, at: index)
        } else {
            toView.addSubview(child.view)
        }
        
        if animationDuration > 0 {
            UIView.animate(
                withDuration: animationDuration,
                animations: {
                    child.view.alpha = 1.0
            })
        } else {
            child.view.alpha = 1.0
        }
    }
    
    /*
     * Call this function on a child view controller to remove it from it's parent controller and dismiss it.
     */
    func remove(fromParentWithAnimationDuration animationDuration:TimeInterval) {
        if animationDuration <= 0 {
            // handle without animation here
            self.view.alpha = 0.0
            willMove(toParentViewController: nil)
            view.removeFromSuperview()
            removeFromParentViewController()
            return
        }
        
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                self.view.alpha = 0.0
        }) { (finished) in
            // notify child it's being removed
            self.willMove(toParentViewController: nil)
            
            // remove the view
            self.view.removeFromSuperview()
            
            // remove child controller from container
            self.removeFromParentViewController()
        }
    }
    
    func showAlert(title:String, message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            
            let ok = UIAlertAction.init(title: "OK", style: .cancel, handler: nil)
            
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
