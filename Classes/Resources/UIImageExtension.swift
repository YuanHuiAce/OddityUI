//
//  UIImageExtension.swift
//  OddityUI
//
//  Created by Mister on 16/8/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension UIImage{
    
    class func SharePlaceholderImage() -> UIImage{
    
        
        return imageWithColor(UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1), size: CGSize(width: 800, height: 800))
    }
    
//    static let sharePlaceholderImage : UIImage = {
//    
//        return imageWithColor(UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1), size: CGSize(width: 800, height: 800))
//    }()
    
    
    class func imageWithColor(_ color:UIColor,size:CGSize) -> UIImage{
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
