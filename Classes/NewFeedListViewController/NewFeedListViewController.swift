//
//  NewFeedListViewController.swift
//  OddityUI
//
//  Created by Mister on 16/8/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit
import XLPagerTabStrip
import RealmSwift


open class NewFeedListViewController: UIViewController,IndicatorInfoProvider,WaitLoadProtcol {
    
    open var odditySetting:OdditySetting!
    open var oddityDelegate:OddityUIDelegate?
    
    var predelegate:NewslistViewControllerNoLikeDelegate!
    
    public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: self.title ?? " ")
        
        return info
    }

    
    var waitView:WaitView!
    
    var channel:Channel?
    var newsResults:Results<New> = New.allArray()
    
    
    var hidden = true
    var timer = Timer()
    var notificationToken: NotificationToken!
    
    @IBOutlet var tableView: UITableView!

    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if self.channel == nil {return}
        
        self.HandleNewFeedMakeChange()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        New.DeleteBecTooMore(cid: self.channel!.id)
        
        self.tableView.mj_header = NewRefreshHeaderView(refreshingBlock: {
            
            self.refreshNewsDataMethod(create:true,show: true)
        })
        
        self.tableView.mj_footer = NewRefreshFooterView {
            
            self.loadNewsDataMethod()
        }
        
        DispatchQueue.main.async {
            
            self.refreshNewsDataMethod(del: true,create:true,show: true)
        }
    }
    
    /**
     下拉刷新 获取更新的新闻数据
     当用户第一次进入时，数据往往是不存在，首先需要上拉加载一些数据。
     只有在当前频道为奇点频道的时候才会展示加载成功消息
     
     默认请求第一张 的 20条新闻消息
     
     - parameter show: 是否显示加载成功消息
     */
    fileprivate func refreshNewsDataMethod(del delete:Bool = false,create:Bool = false,show:Bool = false){
        
        let count = self.newsResults.count
        
        if newsResults.count <= 0 {
            
            self.showWaitLoadView()
            
            NewAPI.LoadNew(cid: self.channel?.id ?? 1, tcr: Date().dateByAddingHours(-1).UnixTimeString(), complete: { ( success) in
                
                let aferCount = self.newsResults.count - count
                
                let message = aferCount > 0 ? "共加载\(aferCount)个数据" : "已经是最新内容"
                
                self.handleMessageShowMethod(message, show: show,bc:success ? UIColor.a_color2 : UIColor.a_noConn)
            })
            
        }else if let last = self.newsResults.first{
            
            var time = last.ptimes
            
            if last.ptimes.hoursBeforeDate(Date()) >= 12{
                
                time = Date().dateByAddingHours(-11)
            }
            
            time.dateByAddingHours(-1)
            
            NewAPI.RefreshNew(cid: self.channel?.id ?? 1, tcr: time.UnixTimeString(), delete: delete, create: create, complete: { ( success) in
                
                let aferCount = self.newsResults.count - count
                
                let message = aferCount > 0 ? "共加载\(aferCount)个数据" : "已经是最新内容"
                
                self.handleMessageShowMethod(message, show: show,bc:success ? UIColor.a_color2 : UIColor.a_noConn)
            })
        }else{
            self.handleMessageShowMethod("未知错误", show: true,bc: UIColor.a_noConn)
        }
    }
    
    /**
     上拉加载
     */
    fileprivate func loadNewsDataMethod(){
    
        if let channelId = self.channel?.id,let last = self.newsResults.last {
            
            NewAPI.LoadNew(cid: self.channel?.id ?? 1, tcr: last.ptimes.UnixTimeString(), complete: { ( success) in
                
                
            })
        }
    }
    
    func HandleNewFeedMakeChange(){
        
        /**
         *  监视当前新闻发生变化之后，进行数据的刷新
         */
        self.notificationToken = newsResults.addNotificationBlock { [weak self](changes: RealmCollectionChange) in
             guard let tableView = self?.tableView else { return }
            self?.hiddenWaitLoadView()
            
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                self?.tableView.reloadData()
//                self?.tableView.beginUpdates()
//                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .fade)
//                self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .bottom)
//                self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .fade)
//                self?.tableView.endUpdates()
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    
    
    func Show(message message:String,backColor:UIColor){
        
        let messageLabel = UILabel()
        
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.backgroundColor = backColor
        
        self.view.addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { (make) in
            
            make.top.equalTo(-40)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(40)
        }
        
        self.Animates(messageLabel: messageLabel,constraint: 40) { (_) in
            
            let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(1.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
                
                self.Animates(messageLabel: messageLabel,constraint: -40, completion: { (_) in
                    
                    messageLabel.removeFromSuperview()
                })
            })
        }
    }
    
    
    private func Animates(messageLabel:UILabel,constraint:CGFloat,completion: ((Bool) -> Swift.Void)? = nil){
        
        UIView.animate(withDuration: 0.3, animations: {
            
            messageLabel.transform = CGAffineTransform(translationX: 0, y: constraint)

            }, completion: completion)
    }

}


// MARK: - 显示刷新数目视图的处理方法集合
extension NewFeedListViewController{
    
    /**
     处理消息提示显示方法，和初始化方法
     */
    fileprivate func handleMessageShowMethod(_ message:String="",show:Bool,bc:UIColor=UIColor.a_color2){
        self.hiddenWaitLoadView()
        
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        if !show {return}
        
        self.Show(message: message, backColor: bc)
    }
}
