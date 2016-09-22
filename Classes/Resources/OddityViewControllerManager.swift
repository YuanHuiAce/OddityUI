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

public extension OddityViewControllerManager{

    /**
     获得频道列表管理视图
     
     - returns: 频道管理视图
     */
    public func getsChannelsManagerViewController() -> ChannelsManagerViewController{ return self.storyBoard.instantiateViewController(withIdentifier: "ChannelsManagerViewController") as! ChannelsManagerViewController }
    /**
     获得频道列表视图
     
     - returns: 频道管理视图
     */
    public func getsNewFeedListViewController() -> NewFeedListViewController{ return self.storyBoard.instantiateViewController(withIdentifier: "NewFeedListViewController") as! NewFeedListViewController }
    
    
    // 获得详情和评论朱世玉视图
    func getDetailAndCommitViewController (_ new:New)-> DetailAndCommitViewController{
        
        let viewController = self.storyBoard.instantiateViewController(withIdentifier: "DetailAndCommitViewController") as! DetailAndCommitViewController
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得详情视图
    func getDetailViewController (_ new:New?)-> DetailViewController{
        
        let viewController = self.storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得评论视图
    func getCommitViewController (_ new:New?)-> CommitViewController{
        
        let viewController = self.storyBoard.instantiateViewController(withIdentifier: "CommitViewController") as! CommitViewController
        
        viewController.new = new
        
        return viewController
    }
    
    // 获得管理频道视图
    func getChannelViewController ()-> ChannelViewController{
        
        let viewController = self.storyBoard.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
        
        return viewController
    }
}
