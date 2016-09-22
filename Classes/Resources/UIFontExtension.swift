//
//  UIFontExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/17.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

let FONTMODALSTYLEIDENTIFITER = "FontModalStyle"

public extension UIFont{

    ///-1 为小字体 0 为普通字体 1 为大字体 2 超大字体
    public class var a_fontModalStyle:Float{
        get {return UserDefaults.standard.float(forKey: FONTMODALSTYLEIDENTIFITER)}
        set(new){
            UserDefaults.standard.set(new, forKey: FONTMODALSTYLEIDENTIFITER)
            NotificationCenter.default.post(name: Notification.Name(rawValue: FONTMODALSTYLEIDENTIFITER), object: nil)
        }
    }
    
    internal class var a_font1:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 20)
            case 1:
                return UIFont.systemFont(ofSize: 22)
            case 2:
                return UIFont.systemFont(ofSize: 24)
            default:
                return UIFont.systemFont(ofSize: 19)
            }
        }
    }
    
    internal class var a_font2:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 19)
            case 1:
                return UIFont.systemFont(ofSize: 21)
            case 2:
                return UIFont.systemFont(ofSize: 23)
            default:
                return UIFont.systemFont(ofSize: 17)
            }
        }
    }
    
    internal class var a_font3:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 18)
            case 1:
                return UIFont.systemFont(ofSize: 20)
            case 2:
                return UIFont.systemFont(ofSize: 22)
            default:
                return UIFont.systemFont(ofSize: 17)
            }
        }
    }
    
    internal class var a_font3_1:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.boldSystemFont(ofSize: 17)
            case 1:
                return UIFont.boldSystemFont(ofSize: 18)
            case 2:
                return UIFont.boldSystemFont(ofSize: 19)
            default:
                return UIFont.boldSystemFont(ofSize: 16)
            }
        }
    }
    
    internal class var a_font3_3:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 17)
            case 1:
                return UIFont.systemFont(ofSize: 18)
            case 2:
                return UIFont.systemFont(ofSize: 19)
            default:
                return UIFont.systemFont(ofSize: 16)
            }
        }
    }
    
    internal class var a_font3_2:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 16)
            case 1:
                return UIFont.systemFont(ofSize: 17)
            case 2:
                return UIFont.systemFont(ofSize: 18)
            default:
                return UIFont.systemFont(ofSize: 15)
            }
        }
    }
    
    internal class var a_font4:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 16)
            case 1:
                return UIFont.systemFont(ofSize: 18)
            case 2:
                return UIFont.systemFont(ofSize: 20)
            default:
                return UIFont.systemFont(ofSize: 14)
            }
        }
    }
    
    internal class var a_font5:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 14)
            case 1:
                return UIFont.systemFont(ofSize: 16)
            case 2:
                return UIFont.systemFont(ofSize: 18)
            default:
                return UIFont.systemFont(ofSize: 14)
            }
        }
    }
    
    internal class var a_font6:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 12)
            case 1:
                return UIFont.systemFont(ofSize: 14)
            case 2:
                return UIFont.systemFont(ofSize: 16)
            default:
                return UIFont.systemFont(ofSize: 11)
            }
        }
    }
    
    internal class var a_font7:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 10)
            case 1:
                return UIFont.systemFont(ofSize: 12)
            case 2:
                return UIFont.systemFont(ofSize: 14)
            default:
                return UIFont.systemFont(ofSize: 10)
            }
        }
    }
    
    /// 相关新闻年份
    internal class var a_font8:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 13)
            case 1:
                return UIFont.systemFont(ofSize: 15)
            case 2:
                return UIFont.systemFont(ofSize: 17)
            default:
                return UIFont.systemFont(ofSize: 12)
            }
        }
    }
    
    /// 新闻标题
    internal class var a_font9:UIFont{
        get{
            switch self.a_fontModalStyle {
            case 0:
                return UIFont.systemFont(ofSize: 25)
            case 1:
                return UIFont.systemFont(ofSize: 27)
            case 2:
                return UIFont.systemFont(ofSize: 29)
            default:
                return UIFont.systemFont(ofSize: 23)
            }
        }
    }
}
