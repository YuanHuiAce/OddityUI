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
    
    override var canBecomeFirstResponder : Bool {
        
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        return action == #selector(CopyLabel.copy(_:))
    }

    override func copy(_ sender: Any?) {
        let pboard = UIPasteboard.general
        pboard.string = self.text
    }
    
//    override func copy(_ sender: AnyObject?) {
//        
//        let pboard = UIPasteboard.general
//        pboard.string = self.text
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.attachTapHandler()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.attachTapHandler()
    }
    
    fileprivate func attachTapHandler(){
    
        let tap = UILongPressGestureRecognizer { (recongnizer) in
            
            if recongnizer.state != .began {return}
            
            self.becomeFirstResponder()
            
            self.menu = UIMenuController.shared
            self.menu.setTargetRect(self.frame, in: self.superview!)
            self.menu.setMenuVisible(true, animated: true)
            
            self.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIMenuControllerDidHideMenu, object: nil, queue: OperationQueue.main) { (noti) in
            
            self.backgroundColor = UIColor.white
        }
        
        self.addGestureRecognizer(tap)
    }
}
