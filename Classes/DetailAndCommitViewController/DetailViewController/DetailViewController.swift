//
//  DetailViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import WebKit
import MJRefresh
import RealmSwift
import XLPagerTabStrip

extension DetailViewController{
    
    /// 获取单例模式下的UIStoryBoard对象
//    var webView:WKWebView!{
//        
//        get{
//            
//            struct backTaskLeton{
//                
//                static var predicate:dispatch_once_t = 0
//                
//                static var bgTask:WKWebView? = nil
//            }
//            
//            dispatch_once(&backTaskLeton.predicate, { () -> Void in
//                
//                let configuration = WKWebViewConfiguration()
//                configuration.userContentController.addScriptMessageHandler(self, name: "JSBridge")
//                configuration.allowsInlineMediaPlayback = true
//                backTaskLeton.bgTask = WKWebView(frame: CGRect(origin: CGPointZero, size: CGSize(width: 600, height: 1000)), configuration: configuration)
//            })
//            
//            return backTaskLeton.bgTask
//        }
//    }
}



open class DetailViewController: UIViewController,WaitLoadProtcol {
    
    var webView:WKWebView!
    
    var waitView:WaitView!
    var new:New? // 当前要展示的新闻对象
    
    var dismiss = false
    var fdismiss = false
    
    let realm = try! Realm()
    
    var ShowF:DetailAndCommitViewController!
    
    var newCon:NewContent!
    var hotResults:Results<Comment>!
    var aboutResults:Results<About>!
    
    @IBOutlet var tableView: UITableView!
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 64
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        if let new = new {
            
            newCon = new.getNewContentObject()
            
            aboutResults = realm.objects(About.self).filter("nid = \(new.nid)").sorted(byProperty: "ptimes", ascending: false)
            
            hotResults = realm.objects(Comment.self).filter("nid = \(new.nid) AND ishot = 1").sorted(byProperty: "commend", ascending: false)

            CommentUtil.LoadNoramlCommentsList(new)
            
            CommentUtil.LoadHotsCommentsList(new, finish: { 
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
                
                }, fail: nil)
            
            AboutUtil.getAboutListArrayData(new , finish: { (_) in
                
                DispatchQueue.main.async {
                    
                    self.tableView.reloadData()
                }
                
                }, fail: nil)
        }
        
        self.tableView.contentInset.bottom = 44
        
        self.integrationMethod()
    }
    
    func setCollectionButton(){
        
        let indexPath = IndexPath(item: 0, section: 0)
        
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
}


extension DetailViewController:IndicatorInfoProvider{

    /**
      当设备的方向发生变化时，将会调用这个方法
     当设备的方向发生了变化之后，我们要为之重新设置详情页中webview的高度。
     
     - parameter size:        方向完成后的大小
     - parameter coordinator: 方向变化的动画渐变对象
     */
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            
            self.webView.evaluateJavaScript("fixedImageHeightAndWidth()", completionHandler: nil)
            
            print("横屏书评 发生变化 刷新表格")
            
            self.tableView.reloadData()
            
            }, completion: nil)
        
    }
    
    /**
     PageView DataSource 设置当前识图的标题
     
     - parameter pagerTabStripController: 视图对象
     - returns: 标题对象
     */
    public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let info = IndicatorInfo(title: "评论")
        
        return info
    }
}
