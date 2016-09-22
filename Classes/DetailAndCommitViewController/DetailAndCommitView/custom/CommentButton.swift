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
        
        self.setTitleColor(UIColor.a_color4, for: UIControlState.disabled)
        self.setTitleColor(UIColor.white, for: UIControlState())
        
        self.setBackgroundColor(UIColor.a_color11, forState: UIControlState.disabled)
        self.setBackgroundColor(UIColor.red, forState: UIControlState())
        
        self.layer.cornerRadius = 2
        
        self.clipsToBounds = true
        
        self.layer.borderWidth = isEnabled ? 0 : 1
        self.layer.borderColor = isEnabled ? UIColor.clear.cgColor : UIColor.a_color4.cgColor
    }
    
    override var isEnabled: Bool{
    
        didSet{
        
            self.layer.borderWidth = isEnabled ? 0 : 1
            self.layer.borderColor = isEnabled ? UIColor.clear.cgColor : UIColor.a_color4.cgColor
        }
    }
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor?, forState state: UIControlState) {
        guard let color = color else { return setBackgroundImage(nil, for: state) }
        setBackgroundImage(UIImage.imageColored(color), for: state)
    }
}

extension UIImage {
    class func imageColored(_ color: UIColor) -> UIImage! {
        let onePixel = 1 / UIScreen.main.scale
        let rect = CGRect(x: 0, y: 0, width: onePixel, height: onePixel)
        UIGraphicsBeginImageContextWithOptions(rect.size, color.cgColor.alpha == 1, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
