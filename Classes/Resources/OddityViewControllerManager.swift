//
//  OddityViewControllerManager.swift
//  OddityUI
//
//  Created by Mister on 16/8/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

public class OddityViewControllerManager: NSObject {
    
    public var storyBoard:UIStoryboard!
    
    public class var shareManager:OddityViewControllerManager!{
        get{
            struct backTaskLeton{
                static var predicate:dispatch_once_t = 0
                static var bgTask:OddityViewControllerManager? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                backTaskLeton.bgTask = OddityViewControllerManager()
                backTaskLeton.bgTask!.storyBoard = UIStoryboard(name: "Oddity", bundle: NSBundle.OddityBundle())
            })
            return backTaskLeton.bgTask
        }
    }
}

public extension OddityViewControllerManager{

    /**
     获得频道列表管理视图
     
     - returns: 频道管理视图
     */
    public func getsChannelsManagerViewController() -> ChannelsManagerViewController{ return self.storyBoard.instantiateViewControllerWithIdentifier("ChannelsManagerViewController") as! ChannelsManagerViewController }
    /**
     获得频道列表视图
     
     - returns: 频道管理视图
     */
    public func getsNewFeedListViewController() -> NewFeedListViewController{ return self.storyBoard.instantiateViewControllerWithIdentifier("NewFeedListViewController") as! NewFeedListViewController }
    
    
    // 获得详情和评论朱世玉视图
    func getDetailAndCommitViewController (new:New)-> DetailAndCommitViewController{
        
        let viewController = self.storyBoard.instantiateViewControllerWithIdentifier("DetailAndCommitViewController") as! DetailAndCommitViewController
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得详情视图
    func getDetailViewController (new:New?)-> DetailViewController{
        
        let viewController = self.storyBoard.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得评论视图
    func getCommitViewController (new:New?)-> CommitViewController{
        
        let viewController = self.storyBoard.instantiateViewControllerWithIdentifier("CommitViewController") as! CommitViewController
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得管理频道视图
    func getChannelViewController ()-> ChannelViewController{
        
        let viewController = self.storyBoard.instantiateViewControllerWithIdentifier("ChannelViewController") as! ChannelViewController
        
        return viewController
    }
}