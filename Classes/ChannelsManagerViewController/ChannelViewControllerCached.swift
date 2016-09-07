//
//  ChannelViewControllerCached.swift
//  OddityUI
//
//  Created by Mister on 16/8/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

/// 属性字符串 缓存器
class ChannelViewControllerCached {
    
    lazy var cache = NSCache()
    
    class var sharedCached:ChannelViewControllerCached!{
        get{
            struct backTaskLeton{
                static var predicate:dispatch_once_t = 0
                static var instance:ChannelViewControllerCached? = nil
            }
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                backTaskLeton.instance = ChannelViewControllerCached()
            })
            return backTaskLeton.instance
        }
    }
    
    /**
     根据提供的 title 字符串 （title 针对于频道时唯一的，可以当作唯一标识来使用）在缓存中获取UIViewController
     
     - parameter string: 原本 字符串
     - parameter font:   字体 对象 默认为 系统2号字体
     
     - returns: 返回属性字符串
     */
    func titleForViewController(channel : Channel) -> NewFeedListViewController {
        
        if let channelViewController = self.cache.objectForKey(channel.cname) as? NewFeedListViewController { return channelViewController }
        
        let channelViewController = getDisplayViewController(channel.cname)
        
        channelViewController.channel = channel
        
        if channel.id == 1{
            
            channelViewController.newsResults = New.allArray().filter("ishotnew = 1 AND isdelete = 0")
        }else{
            
            channelViewController.newsResults = New.allArray().filter("(ANY channelList.channel = %@ AND isdelete = 0 ) OR ( channel = %@ AND isidentification = 1 )",channel.id,channel.id)
        }
        
        self.cache.setObject(channelViewController, forKey: channel.cname)
        
        return channelViewController
    }
    
    /**
     根据提供的 频道的 标题，生成一个 新闻 feed 流儿试图
     
     - parameter cname: 频道标题
     
     - returns: 新闻列表视图
     */
    private func getDisplayViewController(cname : String) -> NewFeedListViewController{
        
        let displayViewController = OddityViewControllerManager.shareManager.getsNewFeedListViewController()
        
        //        displayViewController.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        
        displayViewController.title = cname
        
        return displayViewController
    }
}