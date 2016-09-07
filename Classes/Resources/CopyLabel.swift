//
//  CopyLabel.swift
//  Journalism
//
//  Created by Mister on 16/6/12.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

/// 长按 UILabel 复制文字
class CopyLabel: UILabel {
    
    var menu:UIMenuController!
    
    override func canBecomeFirstResponder() -> Bool {
        
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        
        return action == #selector(NSObject.copy(_:))
    }

    override func copy(sender: AnyObject?) {
        
        let pboard = UIPasteboard.generalPasteboard()
        pboard.string = self.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.attachTapHandler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.attachTapHandler()
    }
    
    private func attachTapHandler(){
    
        let tap = UILongPressGestureRecognizer { (recongnizer) in
            
            if recongnizer.state != .Began {return}
            
            self.becomeFirstResponder()
            
            self.menu = UIMenuController.sharedMenuController()
            self.menu.setTargetRect(self.frame, inView: self.superview!)
            self.menu.setMenuVisible(true, animated: true)
            
            self.backgroundColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.4)
        }
        
        NSNotificationCenter.defaultCenter().addObserverForName(UIMenuControllerDidHideMenuNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (noti) in
            
            self.backgroundColor = UIColor.whiteColor()
        }
        
        self.addGestureRecognizer(tap)
    }
}
