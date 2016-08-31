//
//  CommentButton.swift
//  Journalism
//
//  Created by Mister on 16/6/2.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class CommentButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.setTitleColor(UIColor.a_color4, forState: UIControlState.Disabled)
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.setBackgroundColor(UIColor.a_color11, forState: UIControlState.Disabled)
        self.setBackgroundColor(UIColor.redColor(), forState: UIControlState.Normal)
        
        self.layer.cornerRadius = 2
        
        self.clipsToBounds = true
        
        self.layer.borderWidth = enabled ? 0 : 1
        self.layer.borderColor = enabled ? UIColor.clearColor().CGColor : UIColor.a_color4.CGColor
    }
    
    override var enabled: Bool{
    
        didSet{
        
            self.layer.borderWidth = enabled ? 0 : 1
            self.layer.borderColor = enabled ? UIColor.clearColor().CGColor : UIColor.a_color4.CGColor
        }
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor?, forState state: UIControlState) {
        guard let color = color else { return setBackgroundImage(nil, forState: state) }
        setBackgroundImage(UIImage.imageColored(color), forState: state)
    }
}

extension UIImage {
    class func imageColored(color: UIColor) -> UIImage! {
        let onePixel = 1 / UIScreen.mainScreen().scale
        let rect = CGRect(x: 0, y: 0, width: onePixel, height: onePixel)
        UIGraphicsBeginImageContextWithOptions(rect.size, CGColorGetAlpha(color.CGColor) == 1, 0)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}