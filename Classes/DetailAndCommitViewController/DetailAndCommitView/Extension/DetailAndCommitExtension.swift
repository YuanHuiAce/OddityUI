//
//  DetailAndCommitViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/5/23.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

//extension DetailAndCommitViewController {
//
//    internal func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        return PresentdAnimation
//    }
//    
//    internal func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        
//        return DismissedAnimation
//    }
//    
//    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        
//        if self.DismissedAnimation.isInteraction {
//            
//            return InteractiveTransitioning
//        }
//        
//        return nil
//    }
//}



extension DetailAndCommitViewController{

    @objc(animationControllerForPresentedController:presentingController:sourceController:) public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    @objc(animationControllerForDismissedController:) public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
    
    @objc(interactionControllerForDismissal:) public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
    
    
    // 切换全屏活着完成反悔上一个界面
    @IBAction func touchViewController(_ sender: AnyObject) {

        if currentIndex == 1 { return self.moveToViewController(at: 0)}
        
        return self.dismiss(animated: true, completion: nil)
    }
    
    // 进行滑动返回上一界面的代码操作
    func pan(_ pan:UIPanGestureRecognizer){

        guard let view = pan.view as? UIScrollView else{return}
        let point = pan.translation(in: view)
        if pan.state == UIGestureRecognizerState.began {
            if view.contentOffset.x > 0 || point.x < 0 {return}
            
            self.DismissedAnimation.isInteraction = true
            
            self.dismiss(animated: true, completion: nil)
            
        }else if pan.state == UIGestureRecognizerState.changed {
            
            let process = point.x/UIScreen.main.bounds.width
            
            self.InteractiveTransitioning.update(process)
            
        }else {
            
            self.DismissedAnimation.isInteraction = false
            
            let loctionX = abs(Int(point.x))
            
            let velocityX = pan.velocity(in: pan.view).x
            
            if velocityX >= 500 || loctionX >= Int(UIScreen.main.bounds.width/2) {
                
                self.InteractiveTransitioning.finish()
                
            }else{
                
                self.InteractiveTransitioning.cancel()
            }
        }
    }
}
