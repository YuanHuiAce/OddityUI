//
//  UIFontExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/17.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

let FONTMODALSTYLEIDENTIFITER = "FontModalStyle"

extension UIFont{

    ///-1 为小字体 0 为普通字体 1 为大字体 2 超大字体
    class var a_fontModalStyle:Float{
        get {return NSUserDefaults.standardUserDefaults().floatForKey(FONTMODALSTYLEIDENTIFITER)}
        set(new){
            NSUserDefaults.standardUserDefaults().setFloat(new, forKey: FONTMODALSTYLEIDENTIFITER)
            NSNotificationCenter.defaultCenter().postNotificationName(FONTMODALSTYLEIDENTIFITER, object: nil)
        }
    }
    
    class var a_font1:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(20)
            case 1:
                return UIFont.systemFontOfSize(22)
            case 2:
                return UIFont.systemFontOfSize(24)
            default:
                return UIFont.systemFontOfSize(19)
            }
        }
    }
    
    class var a_font2:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(19)
            case 1:
                return UIFont.systemFontOfSize(21)
            case 2:
                return UIFont.systemFontOfSize(23)
            default:
                return UIFont.systemFontOfSize(17)
            }
        }
    }
    
    class var a_font3:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(18)
            case 1:
                return UIFont.systemFontOfSize(20)
            case 2:
                return UIFont.systemFontOfSize(22)
            default:
                return UIFont.systemFontOfSize(17)
            }
        }
    }
    
    class var a_font3_1:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.boldSystemFontOfSize(17)
            case 1:
                return UIFont.boldSystemFontOfSize(18)
            case 2:
                return UIFont.boldSystemFontOfSize(19)
            default:
                return UIFont.boldSystemFontOfSize(16)
            }
        }
    }
    
    class var a_font3_2:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(16)
            case 1:
                return UIFont.systemFontOfSize(17)
            case 2:
                return UIFont.systemFontOfSize(18)
            default:
                return UIFont.systemFontOfSize(15)
            }
        }
    }
    
    class var a_font4:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(16)
            case 1:
                return UIFont.systemFontOfSize(18)
            case 2:
                return UIFont.systemFontOfSize(20)
            default:
                return UIFont.systemFontOfSize(14)
            }
        }
    }
    
    class var a_font5:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(14)
            case 1:
                return UIFont.systemFontOfSize(16)
            case 2:
                return UIFont.systemFontOfSize(18)
            default:
                return UIFont.systemFontOfSize(14)
            }
        }
    }
    class var a_font6:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(12)
            case 1:
                return UIFont.systemFontOfSize(14)
            case 2:
                return UIFont.systemFontOfSize(16)
            default:
                return UIFont.systemFontOfSize(11)
            }
        }
    }
    class var a_font7:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(10)
            case 1:
                return UIFont.systemFontOfSize(12)
            case 2:
                return UIFont.systemFontOfSize(14)
            default:
                return UIFont.systemFontOfSize(10)
            }
        }
    }
    
    /// 相关新闻年份
    class var a_font8:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(13)
            case 1:
                return UIFont.systemFontOfSize(15)
            case 2:
                return UIFont.systemFontOfSize(17)
            default:
                return UIFont.systemFontOfSize(12)
            }
        }
    }
    
    /// 新闻标题
    class var a_font9:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFontOfSize(25)
            case 1:
                return UIFont.systemFontOfSize(27)
            case 2:
                return UIFont.systemFontOfSize(29)
            default:
                return UIFont.systemFontOfSize(23)
            }
        }
    }
}
