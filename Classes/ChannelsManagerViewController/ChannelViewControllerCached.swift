//
//  ChannelViewControllerCached.swift
//  OddityUI
//
//  Created by Mister on 16/8/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


// 缓存条件出现问题
//class ChannelViewControllerCachedKey: NSObject {
//    
//    var channelName:String!
//    var managerViewController:UIViewController!
//    
//    init(channelName:String,managerViewController:UIViewController) {
//        
//        self.channelName = channelName
//        self.managerViewController = managerViewController
//    }
//}

/// 属性字符串 缓存器
class ChannelViewControllerCached {
    
    static let sharedCached : ChannelViewControllerCached = { return ChannelViewControllerCached()}()
    
    lazy var cache = NSCache<AnyObject,UIViewController>()

    /**
     根据提供的 title 字符串 （title 针对于频道时唯一的，可以当作唯一标识来使用）在缓存中获取UIViewController
     
     - parameter string: 原本 字符串
     - parameter font:   字体 对象 默认为 系统2号字体
     
     - returns: 返回属性字符串
     */
    func titleForViewController(_ channel : Channel,managerViewController: ChannelsManagerViewController) -> NewFeedListViewController {
        
        let cacheKeyObject = "\(channel.cname) - \(managerViewController.hashValue)"
        
        if let channelViewController = self.cache.object(forKey: cacheKeyObject as AnyObject) as? NewFeedListViewController { return channelViewController }
        
        let channelViewController = getDisplayViewController(channel.cname)
        
        channelViewController.channel = channel
        
        channelViewController.newsResults = New.allArray().filter("(ANY channelList.channel = %@ AND isdelete = 0 ) OR ( channel = %@ AND isidentification = 1 )",channel.id,channel.id)
        
        channelViewController.predelegate = managerViewController
        
        self.cache.setObject(channelViewController, forKey: cacheKeyObject as AnyObject)
        
        return channelViewController
    }
    
    /**
     根据提供的 频道的 标题，生成一个 新闻 feed 流儿试图
     
     - parameter cname: 频道标题
     
     - returns: 新闻列表视图
     */
    fileprivate func getDisplayViewController(_ cname : String) -> NewFeedListViewController{
        
        let displayViewController = OddityViewControllerManager.shareManager.getsNewFeedListViewController()
        
        //        displayViewController.view.backgroundColor = UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
        
        displayViewController.title = cname
        
        return displayViewController
    }
}
