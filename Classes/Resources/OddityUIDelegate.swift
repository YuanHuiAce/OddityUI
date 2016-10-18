//
//  OddityUIDelegate.swift
//  Pods
//
//  Created by Mister on 16/10/18.
//
//

import UIKit

/// 当前SDK某些操作的 通知
@objc public protocol OddityUIDelegate {
    
    /// 当用户查看新闻详情时，点击了某个链接 触发的事件
    @objc optional func clickHyperlinkAction(viewController:UIViewController,urlString:String)
    
    /// 当用户查看新闻详情时，点击某个图片触发的事件
    @objc optional func clickNewContentImageAction (viewController:UIViewController,newContent :NewContent,imgIndex:Int,imgArray:[String])
    
    /// 当用户点击了某一条相关观点
    @objc optional func clickAboutOptionAction(viewController:UIViewController,urlString:String)
}

/// 关于当前SDK的设置
public class OdditySetting: NSObject{

    /// 是否现实相关观点，默认为 true
    public var showAboutOptions:Bool = true
}
