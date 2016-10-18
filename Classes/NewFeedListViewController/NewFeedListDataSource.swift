//
//  NewFeedListDataSource.swift
//  OddityUI
//
//  Created by Mister on 16/8/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import PINCache

//
///// 属性字符串 缓存器
//class TableViewHeightCached {
//    
//    
//    private static var __once: () = { () -> Void in
//                backTaskLeton.instance = TableViewHeightCached()
//            }()
//    
//    lazy var cache = PINMemoryCache()
//    
//    class var sharedHeightCached:TableViewHeightCached!{
//        get{
//            struct backTaskLeton{
//                static var predicate:Int = 0
//                static var instance:TableViewHeightCached? = nil
//            }
//            _ = TableViewHeightCached.__once
//            return backTaskLeton.instance
//        }
//    }
//    
//    func cacheHeight(_ nid : Int,height:CGFloat){
//    
//        self.cache.setObject(height, forKey: "\(nid)")
//    }
//    
//    /**
//     根据提供的 title 字符串 （title 针对于频道时唯一的，可以当作唯一标识来使用）在缓存中获取UIViewController
//     
//     - parameter string: 原本 字符串
//     - parameter font:   字体 对象 默认为 系统2号字体
//     
//     - returns: 返回属性字符串
//     */
//    func heightForNewNID(_ nid : Int ) -> CGFloat {
//        
////        if let channelViewController = self.cache.objectForKey(nid) as? CG { return channelViewController }
////        
////        let channelViewController = getDisplayViewController(channel.cname)
////        
////        channelViewController.channel = channel
////        
////        if channel.id == 1{
////            
////            channelViewController.newsResults = New.allArray().filter("ishotnew = 1 AND isdelete = 0")
////        }else{
////            
////            channelViewController.newsResults = New.allArray().filter("(ANY channelList.channel = %@ AND isdelete = 0 ) OR ( channel = %@ AND isidentification = 1 )",channel.id,channel.id)
////        }
////        
////        self.cache.setObject(channelViewController, forKey: channel.cname)
//        
//        return self.cache.object(forKey: "\(nid)") as? CGFloat ?? -1
//    }
//}



extension NewFeedListViewController:UITableViewDataSource{
    
    
    fileprivate func getTableViewCell(_ indexPath : IndexPath) -> UITableViewCell{
    
        var cell :NewBaseTableViewCell!
        
        let new = newsResults[(indexPath as NSIndexPath).row]
        
        if new.isidentification == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "refreshcell")! as UITableViewCell
            
            return cell
        }
        
        if new.style == 0 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewNormalTableViewCell") as! NewNormalTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 1 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewOneTableViewCell") as! NewOneTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 2 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewTwoTableViewCell") as! NewTwoTableViewCell
            
            cell.setNewObject(new)
            
        }else if new.style == 3 {
            
            cell =  tableView.dequeueReusableCell(withIdentifier: "NewThreeTableViewCell") as! NewThreeTableViewCell
            
            cell.setNewObject(new)
        }else{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "NewTwoTableViewCell") as! NewTwoTableViewCell
            
            switch new.style-10 {
            case 1:
                cell.setNewObject(new,bigImg: 0)
            case 2:
                cell.setNewObject(new,bigImg: 1)
            default:
                cell.setNewObject(new,bigImg: 2)
            }
        }
        
        cell.noLikeButton.removeActions(events: UIControlEvents.touchUpInside)
        cell.noLikeButton.addAction(events: UIControlEvents.touchUpInside) { (_) in
            
            self.handleActionMethod(cell, indexPath: indexPath)
        }
        
        if self.channel?.id == 1 {
            
            cell.setPPPLabel(new)
        }
        
        return cell
    }
    
    
    
    /**
     设置新闻的个数
     
     判断当前视图没有newResults对象，如果没有 默认返回0
     有则正常返回其数目
     
     - parameter tableView: 表格对象
     - parameter section:   section index
     
     - returns: 新闻的个数
     */
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsResults.count
    }
    
    /**
     返回每一个新闻的展示
     其中当遇到 这个新闻的 `isidentification` 的标示为 1 的时候，说明这条新闻是用来显示一个刷新视图的。
     其它的新闻会根据起 style 参数进行 没有图 一张图 两张图 三张图的 新闻展示形式进行不同形式的展示
     
     - parameter tableView: 表格对象
     - parameter indexPath: 当前新闻展示的位置
     
     - returns: 返回新闻的具体战士杨视图
     */
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        return self.getTableViewCell(indexPath)
    }
    
    /**
     处理用户的点击新闻视图中的 不喜欢按钮处理方法
     
     首先获取当前cell基于注视图的point。用于传递给上层视图进行 cell 新闻的展示
     计算cell所在的位置，之后预估起全部展开的位置大小，是否会被遮挡，如果被遮挡 ，就先进性cel的移动，使其不会被遮挡
     之后将这个cell和所在的point传递给上层视图 使用的传递工具为 delegate
     之后上层视图处理完成之后，返回是否删除动作，当前tableview进行删除或者刷新cell
     
     - parameter cell:      返回被点击的cell
     - parameter indexPath: 被点击的位置
     */
    fileprivate func handleActionMethod(_ cell :NewBaseTableViewCell,indexPath:IndexPath){
        
        var delayInSeconds = 0.0
        
        let porint = cell.convert(cell.bounds, to: self.view).origin
        
        if porint.y < 0 {
            
            delayInSeconds = 0.5
            
            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        }
        
        let needHeight = porint.y+cell.frame.height+128
        
        if  needHeight > self.tableView.frame.height {
            
            delayInSeconds = 0.5
            
            let result = needHeight-self.tableView.frame.height
            
            let toPoint = CGPoint(x: 0, y: self.tableView.contentOffset.y+result)
            
            self.tableView.setContentOffset(toPoint, animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { // 2
            
            self.predelegate.ClickNoLikeButtonOfUITableViewCell?(cell, finish: { (cancel) in
                
                if !cancel {
                    
                    self.newsResults[(indexPath as NSIndexPath).row].suicide()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { // 2
                        
                        self.showNoInterest()
                        
                        self.tableView.reloadData()
                    }
                }else{
                    
                    self.tableView.reloadData()
                }
            })
        }
    }
    
}


extension NewFeedListViewController:UITableViewDelegate{

    /**
     点击cell 之后处理的方法
     如果是刷新的cell就进行当前新闻的刷新
     如果是新闻cell就进行
     
     - parameter tableView: tableview 对象
     - parameter indexPath: 点击的indexPath
     */
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let new = newsResults[(indexPath as NSIndexPath).row]

        if new.isidentification == 1 {
            
            return self.tableView.mj_header.beginRefreshing()
        }
        
        let viewController = OddityViewControllerManager.shareManager.getDetailAndCommitViewController(new)
        
        viewController.odditySetting = self.odditySetting
        viewController.oddityDelegate = self.oddityDelegate
        
        self.show(viewController, sender: nil)
        
        if new.isread == 0 {
            
            new.isRead() // 设置为已读
        }
        
    }
}
