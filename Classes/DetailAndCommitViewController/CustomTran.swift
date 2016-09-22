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
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, at: 0)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.transform = fromViewController.view.transform.translatedBy(x: fromViewController.view.bounds.width, y: 0)
            
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
            
        }, completion: { (_) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }) 
    }
}

class CustomViewControllerPresentdAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!

        
        let containerView = transitionContext.containerView
        containerView.addSubview(toViewController.view)
        
        
        toViewController.view.transform = toViewController.view.transform.translatedBy(x: toViewController.view.bounds.width, y: 0)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.transform = fromViewController.view.transform.scaledBy(x: 0.95, y: 0.95)
        }, completion: { (_) in
            
            transitionContext.completeTransition(true)
        }) 
    }
}
