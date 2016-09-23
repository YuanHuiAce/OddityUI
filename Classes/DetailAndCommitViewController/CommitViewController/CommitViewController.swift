//
//  CommitViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

open class CommitViewController: UIViewController,IndicatorInfoProvider {
    public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        let info = IndicatorInfo(title: "评论")
        
        return info
    }

    
    var new:New?
    
    var currentPage = 1
    
    var hotResults:Results<Comment>!
    var normalResults:Results<Comment>!
    
    @IBOutlet var newInfoLabel: UILabel!
    @IBOutlet var newTitleLabel: UILabel!

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var tableViewHeaderView: UIView!

    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setResults()
        self.setHeaderView()
        
        
        self.tableView.estimatedRowHeight = 64
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.contentInset.bottom = 44
        
        if let new = new {
            
            if new.comment <= 0 {return}
            
            let footer = NewRefreshFooterView {
                
                self.currentPage = self.currentPage + 1
                
                CommentUtil.LoadNoramlCommentsList(new, p: "\(self.currentPage)", c: "20", finish: { (count) in
                    
                    if count < 20 {
                        
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                        
                    }else{
                        
                        self.tableView.mj_footer.endRefreshing()
                    }
                    
                    self.tableView.reloadData()
                    }, fail: {
                        
                        self.tableView.mj_footer.endRefreshing()
                })
            }
            
            self.tableView.mj_footer = footer
        }
        
        
        // 获得字体变化通知，完成刷新字体大小方法
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: FONTMODALSTYLEIDENTIFITER), object: nil, queue: OperationQueue.main) { (_) in
            
            self.setHeaderView()
            self.tableView.reloadData()
        }
    }
}
