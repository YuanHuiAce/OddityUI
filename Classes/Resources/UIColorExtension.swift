//
//  UIColorExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/14.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

extension UIColor{

    /**
     获得随机的颜色
     */
    class func RandmColor() -> String{
    
        switch arc4random_uniform(5) {
        case 0:
            return "#f46b75"
        case 1:
            return "#a87dd7"
        case 2:
            return "#5994e3"
        case 3:
            return "#85ca4b"
        case 4:
            return "#eba85d"
        default:
            return "#64b6eb"
        }
    }
    
    /// 频道字颜色
    class var a_color1:UIColor{  return UIColor.hexStringToColor("#333333")}
    /// 产品主颜色
    class var a_color2:UIColor{  return UIColor.hexStringToColor("#0091fa")}
    /// 新闻标题颜色
    class var a_color3:UIColor{  return UIColor.hexStringToColor("#1a1a1a")}
    /// 频新闻来源颜色
    class var a_color4:UIColor{  return UIColor.hexStringToColor("#999999")}
    /// 分割线颜色
    class var a_color5:UIColor{  return UIColor.hexStringToColor("#e4e4e4")}
    /// 置顶颜色
    class var a_color6:UIColor{  return UIColor.hexStringToColor("#bb1c1c")}
    /// 提示颜色
    class var a_color7:UIColor{  return UIColor.hexStringToColor("#666666")}
    /// 加载条颜色
    class var a_color8:UIColor{  return UIColor.hexStringToColor("#d9effe")}
    /// 背景颜色
    class var a_color9:UIColor{  return UIColor.hexStringToColor("#f6f6f6")}
    /// 分割线颜色
    class var a_color10:UIColor{  return UIColor.hexStringToColor("#c0c0c0")}
    
    /// 评论按钮背景颜色
    class var a_color11:UIColor{  return UIColor.hexStringToColor("#eaeaea")}
    
    class var a_wifi:UIColor{return UIColor.hexStringToColor("#FF7F00")}
    class var a_cellular:UIColor{return UIColor.hexStringToColor("#FFA07A")}
    class var a_noConn:UIColor{return UIColor.hexStringToColor("#FF6347")}
}


struct ColorComponents {
    var r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat
}

extension UIColor {
    
    func getComponents() -> ColorComponents {
        if (CGColorGetNumberOfComponents(self.CGColor) == 2) {
            let cc = CGColorGetComponents(self.CGColor);
            return ColorComponents(r:cc[0], g:cc[0], b:cc[0], a:cc[1])
        }
        else {
            let cc = CGColorGetComponents(self.CGColor);
            return ColorComponents(r:cc[0], g:cc[1], b:cc[2], a:cc[3])
        }
    }
    
    func interpolateRGBColorTo(end: UIColor, fraction: CGFloat) -> UIColor {
        var f = max(0, fraction)
        f = min(1, fraction)
        
        let c1 = self.getComponents()
        let c2 = end.getComponents()
        
        let r: CGFloat = CGFloat(c1.r + (c2.r - c1.r) * f)
        let g: CGFloat = CGFloat(c1.g + (c2.g - c1.g) * f)
        let b: CGFloat = CGFloat(c1.b + (c2.b - c1.b) * f)
        let a: CGFloat = CGFloat(c1.a + (c2.a - c1.a) * f)
        
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
    
}


extension UIColor{

//    func interpolateRGBColorTo(end:UIColor, fraction:CGFloat) -> UIColor {
//        var f = max(0, fraction)
//        f = min(1, fraction)
//        
//        let c1 = CGColorGetComponents(self.CGColor)
//        let c2 = CGColorGetComponents(end.CGColor)
//        
//        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
//        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
//        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
//        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
//        
//        return UIColor.init(red:r, green:g, blue:b, alpha:1)
//    }
    
    
    func ColorByProcess(toColor:UIColor,progress:CGFloat) -> UIColor{
    
        let old = CGColorGetComponents(self.CGColor)
        
        let ored = old[0]
        let ogreen = old[1]
        let oorange = old[2]
        
        let new = CGColorGetComponents(toColor.CGColor)
        
        let nred = new[0]
        let ngreen = new[1]
        let norange = new[2]
        
        let finred = (1 - progress)*ored + progress*nred
        let fingreen = (1 - progress)*ogreen + progress*ngreen
        let finorange = (1 - progress)*oorange + progress*norange
        
        return UIColor(red: finred, green: fingreen, blue: finorange, alpha: 1)
    }
}


extension UIColor{
    public class func hexStringToColor(hexString: String) -> UIColor{
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if cString.characters.count < 6 {return UIColor.blackColor()}
        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
        if cString.characters.count != 6 {return UIColor.blackColor()}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substringWithRange(range)
        range.location = 2
        let gString = (cString as NSString).substringWithRange(range)
        range.location = 4
        let bString = (cString as NSString).substringWithRange(range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        NSScanner.init(string: rString).scanHexInt(&r)
        NSScanner.init(string: gString).scanHexInt(&g)
        NSScanner.init(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
}