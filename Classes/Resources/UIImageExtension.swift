//
//  UIImageExtension.swift
//  OddityUI
//
//  Created by Mister on 16/8/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension UIImage{
    
    
    /// 获取单例模式下的UIStoryBoard对象
    class var sharePlaceholderImage:UIImage!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:UIImage? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = imageWithColor(UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1), size: CGSize(width: 800, height: 800))
            })
            
            return backTaskLeton.bgTask
        }
    }
    
    
    class func imageWithColor(color:UIColor,size:CGSize) -> UIImage{
        let rect = CGRect(origin: CGPointZero, size: size)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        
        CGContextFillRect(context, rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}