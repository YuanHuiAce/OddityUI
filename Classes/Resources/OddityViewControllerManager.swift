//
//  OddityViewControllerManager.swift
//  OddityUI
//
//  Created by Mister on 16/8/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

open class OddityViewControllerManager: NSObject {
    
    open var storyBoard:UIStoryboard!
    
    static open let shareManager:OddityViewControllerManager = {
        let shareManager = OddityViewControllerManager()
        shareManager.storyBoard = UIStoryboard(name: "Oddity", bundle: Bundle.OddityBundle())
        return shareManager
    }()
    
}

/// 读取UIViewController的辅助类
public struct ViewControllerLoader<T:UIViewController> {
    
    static func ViewController() -> T{
        
        guard let viewController = UIStoryboard(name: "Oddity", bundle: Bundle.OddityBundle()).instantiateViewController(withIdentifier: String(describing: T.self)) as? T else { fatalError("无获取") }
        
        return viewController
    }
}

public extension OddityViewControllerManager{

    /**
     获得频道列表管理视图
     
     - returns: 频道管理视图
     */
    public func getsChannelsManagerViewController() -> ChannelsManagerViewController{
        
        return ChannelsManagerViewController()
    }
    /**
     获得频道列表视图
     
     - returns: 频道管理视图
     */
    public func getsNewFeedListViewController() -> NewFeedListViewController{
        
        return ViewControllerLoader<NewFeedListViewController>.ViewController()
    }
    
    
    // 获得详情和评论朱世玉视图
    func getDetailAndCommitViewController (_ new:New)-> DetailAndCommitViewController{
        
        let viewController = ViewControllerLoader<DetailAndCommitViewController>.ViewController()
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得详情视图
    func getDetailViewController (_ new:New?)-> DetailViewController{
        
        let viewController = ViewControllerLoader<DetailViewController>.ViewController()
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得评论视图
    func getCommitViewController (_ new:New?)-> CommitViewController{
        
        let viewController = ViewControllerLoader<CommitViewController>.ViewController()
        
        viewController.new = new
        
        return viewController
    }
    
    /// 获得管理频道视图
    //  该试图 用于 展示 频道列表 让用户得
    //
    func getChannelViewController ()-> ChannelViewController{
        
        let viewController = ViewControllerLoader<ChannelViewController>.ViewController()
        
        return viewController
    }
}
