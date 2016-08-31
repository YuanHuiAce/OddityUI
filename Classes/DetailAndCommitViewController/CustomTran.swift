//
//  CustomTransitioning.swift
//  Journalism
//
//  Created by Mister on 16/5/26.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class CustomViewControllerDismissedAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    var isInteraction = false
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let containerView = transitionContext.containerView()
        containerView!.addSubview(toViewController.view)
        containerView!.addSubview(fromViewController.view)
        
        toViewController.view.frame = transitionContext.finalFrameForViewController(toViewController)
        
        dispatch_async(dispatch_get_main_queue()) { 
            
            toViewController.view.transform = CGAffineTransformIdentity
            toViewController.view.transform = CGAffineTransformScale(toViewController.view.transform, 0.9, 0.9)
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
                
                toViewController.view.transform = CGAffineTransformIdentity
                fromViewController.view.transform = CGAffineTransformTranslate(fromViewController.view.transform, fromViewController.view.bounds.width, 0)
            }) { (_) in
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            }
        }
    }
}

class CustomViewControllerPresentdAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!

        
        let containerView = transitionContext.containerView()
        containerView!.addSubview(toViewController.view)
        
        
        toViewController.view.transform = CGAffineTransformTranslate(toViewController.view.transform, toViewController.view.bounds.width, 0)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
            
            toViewController.view.transform = CGAffineTransformIdentity
            fromViewController.view.transform = CGAffineTransformScale(fromViewController.view.transform, 0.9, 0.9)
        }) { (_) in
            
            transitionContext.completeTransition(true)
            fromViewController.view.transform = CGAffineTransformIdentity
        }
    }
}