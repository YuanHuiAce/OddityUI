//
//  NewFeedListViewController.swift
//  OddityUI
//
//  Created by Mister on 16/8/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import OddityModal
import XLPagerTabStrip
import RealmSwift

extension NSDate{

    func UnixTimeString() -> String{
    
        return "\(Int64(self.timeIntervalSince1970*1000))"
    }
}

@objc protocol NewslistViewControllerNoLikeDelegate{
    
    /**
     当用户点击不喜欢按钮，出发的delegate
     
     - parameter cell:   不喜欢按钮所在的cell
     - parameter finish: 当用户处理完方法后
     
     - returns: 空
     */
    optional func ClickNoLikeButtonOfUITableViewCell(cell:NewBaseTableViewCell,finish:((cancel:Bool)->Void)) -> Void
}



import JMGTemplateEngine

extension MGTemplateEngine{
    
    /// 获取单例模式下的UIStoryBoard对象
    class var shareTemplateEngine:MGTemplateEngine!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:MGTemplateEngine? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = MGTemplateEngine()
                backTaskLeton.bgTask!.matcher = ICUTemplateMatcher(templateEngine: backTaskLeton.bgTask)
            })
            
            return backTaskLeton.bgTask
        }
    }
}

extension String{
    
    /**
     处理视频文件
     
     - returns: 处理完成的视频文件
     */
    private func HandleForVideoHtml() -> String{
        
        return self.replaceRegex("(preview.html)", with: "player.html")
            .replaceRegex("(allowfullscreen=\"\")", with: "")
            .replaceRegex("(class=\"video_iframe\")", with: "")
            .replaceRegex("(width=[0-9]+&)", with: "")
            .replaceRegex("(height=[0-9]+&)", with: "")
            .replaceRegex("(height=\"[0-9]+\")", with: "")
            .replaceRegex("(width=\"[0-9]+\")", with: "")
            .replaceRegex("(&?amp;)", with: "")
            .replaceRegex("(auto=0)", with: "")
        //            .replaceRegex("(frameborder=\"[0-9]+\")", with: "")
    }
    
    
}

extension NewContent{
    
    func scroffY(y:CGFloat){
        let realm = try! Realm()
        try! realm.write {
            self.scroffY = Double(y)
        }
    }
    
    func getHtmlResourcesString() -> String{
        
        var body = ""
        
        let title = "#title{font-size:\(UIFont.a_font9.pointSize)px;}"
        let subtitle = "#subtitle{font-size:\(UIFont.a_font8.pointSize)px;}"
        let bodysection = "#body_section{font-size:\(UIFont.a_font3.pointSize)px;}"
        
        for conten in self.content{
            
            if let img = conten.img {
                
                var str = "<div class = \"imgDiv\">&img&</div>"
                
                //                var
                
                let res = img.grep("_(\\d+)X(\\d+).").captures
                
                if img.hasSuffix(".gif") {
                    
                    str = "<div class = \"imgDiv\">&span&&img&</div>" // 进度条
                }
                
                if res.count > 0 {
                    
                    if img.hasSuffix(".gif") {
                        
                        str = str.replaceRegex("(&span&)",  with: "<div style=\"height:2px;width:\(res[1])px\" class=\"progress img-responsive center-block customProgress\"><div class=\"progress-bar customProgressBar\" role=\"progressbar\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 0%;\"> <span class=\"sr-only\">40% 完成</span> </div> </div>")
                        
                    }
                    
                    str = str.replaceRegex("(&img&)", with: "<img style=\"display: flex; \" data-src=\"\(img)\" w=\(res[1]) h=\(res[2]) class=\"img-responsive center-block\">")
                    
                }else{
                    
                    str = str.replaceRegex("(&img&)", with: "<img style=\"display: flex; \" data-src=\"\(img)\" class=\"img-responsive center-block\">")
                    
                    str = str.replaceRegex("(&span&)", with: "<div style=\"height:2px;\" class=\"progress customProgress\"><div class=\"progress-bar customProgressBar\" role=\"progressbar\" aria-valuemin=\"0\" aria-valuemax=\"100\" style=\"width: 0%;\"> </div> </div>")
                }
                
                body += str
            }
            
            if let vid = conten.vid {
                
                let str = vid.HandleForVideoHtml()
                
                body += "<div id=\"video\">\(str)</div>"
            }
            
            if let txt = conten.txt {
                
                body += "<p>\(txt)</p>"
            }
        }
        
        
        //        body+="<br/><hr style=\"height:1.5px;border:none;border-top:1px dashed #999999;\" />"
        //        body+="<p style=\"font-size:12px;color:#999999\" align=\"center\" color＝\"#999999\"><span>原网页由 奇点资讯 转码以便移动设备阅读</span></p>"
        //        body+="<p style=\"font-size:12px;\" align=\"center\"><span><a style=\"color:#999999;text-decoration:underline\" href =\"\(self.purl)\">查看原文</a></span></p>"
        
        let templatePath = NSBundle.OddityBundle().pathForResource("content_template", ofType: "html")
        
        let comment = self.comment > 0 ? "   \(self.comment)评" : ""
        
        let variables = ["title":self.title,"source":self.pname,"ptime":self.ptime,"theme":"normal","body":body,"comment":comment,"titleStyle":title,"subtitleStyle":subtitle,"bodysectionStyle":bodysection]
        
        let result = MGTemplateEngine.shareTemplateEngine.processTemplateInFileAtPath(templatePath, withVariables: variables)
        
        return result
    }
}


public class NewFeedListViewController: UIViewController,IndicatorInfoProvider,WaitLoadProtcol {
    
    var waitView:WaitView!
    
    var channel:Channel?
    var newsResults:Results<New> = New.allArray()
    
    var delegate:NewslistViewControllerNoLikeDelegate!
    
    private var timer = NSTimer()
    private var notificationToken: NotificationToken!
    
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    
    public func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: self.title ?? " ")
        
        return info
    }
    
    
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if self.channel == nil {return}
        
        self.messageHandleMethod(hidden:true, anmaiter: false) // 隐藏提示视图
        
        self.HandleNewFeedMakeChange()
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.mj_header = NewRefreshHeaderView(refreshingBlock: {
            
            self.refreshNewsDataMethod(create:true,show: true)
        })
        
        self.tableView.mj_footer = NewRefreshFooterView {
            
            self.loadNewsDataMethod()
        }
        
        self.refreshNewsDataMethod(del: true,create:true,show: true)
    }
    
    /**
     下拉刷新 获取更新的新闻数据
     当用户第一次进入时，数据往往是不存在，首先需要上拉加载一些数据。
     只有在当前频道为奇点频道的时候才会展示加载成功消息
     
     默认请求第一张 的 20条新闻消息
     
     - parameter show: 是否显示加载成功消息
     */
    private func refreshNewsDataMethod(del delete:Bool = false,create:Bool = false,show:Bool = false){
        
        if newsResults.count <= 0 {
            
            self.showWaitLoadView()
            
            return NewAPI.LoadNew(cid: self.channel?.id ?? 1, tcr: NSDate().dateByAddingHours(-1).UnixTimeString())
            
        }else if let last = self.newsResults.first{
            
            var time = last.ptimes
            
            if last.ptimes.hoursBeforeDate(NSDate()) >= 12{
                
                time = NSDate().dateByAddingHours(-11)
            }
            
            time.dateByAddingHours(-1)
            
            NewAPI.RefreshNew(cid: self.channel?.id ?? 1, tcr: time.UnixTimeString(), delete: delete, create: create, complete: { (message, success) in
                
                self.handleMessageShowMethod(message, show: show,bc:success ? UIColor.a_color2 : UIColor.a_noConn)
            })
        }else{
            self.handleMessageShowMethod("未知错误", show: true,bc: UIColor.a_noConn)
        }
    }
    
    /**
     上拉加载
     */
    private func loadNewsDataMethod(){
    
        if let channelId = self.channel?.id,last = self.newsResults.last {
            
            NewAPI.LoadNew(cid: channelId, tcr: last.ptimes.UnixTimeString())
        }
    }
    
    private func HandleNewFeedMakeChange(){
    
        /**
         *  监视当前新闻发生变化之后，进行数据的刷新
         */
        self.notificationToken = newsResults.addNotificationBlock { (changes: RealmCollectionChange) in
            
            self.hiddenWaitLoadView()
            
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            switch changes {
            case .Initial:
                self.tableView.reloadData()
                break
            case .Update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRowsAtIndexPaths(insertions.map { NSIndexPath(forRow: $0, inSection: 0) }, withRowAnimation: UITableViewRowAnimation.Fade)
                self.tableView.deleteRowsAtIndexPaths(deletions.map { NSIndexPath(forRow: $0, inSection: 0) }, withRowAnimation: .Bottom)
                self.tableView.reloadRowsAtIndexPaths(modifications.map { NSIndexPath(forRow: $0, inSection: 0) }, withRowAnimation: .Fade)
                self.tableView.endUpdates()
                break
            case .Error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
}


// MARK: - 显示刷新数目视图的处理方法集合
extension NewFeedListViewController{
    
    /**
     处理消息提示显示方法，和初始化方法
     */
    private func handleMessageShowMethod(message:String="",show:Bool,bc:UIColor=UIColor.a_color2){
        self.hiddenWaitLoadView()
        
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        if !show {return}
        self.messageHandleMethod(message,backColor: bc)
    }
    
    /**
     下拉刷新成功后向用户提醒刷新数目的显示方法
     如果参数 hidden 为 true 则为隐藏，如果为 false 则为 显示
     
     - parameter message:   要向用户展示的消息
     - parameter backColor: 向用户展示的消息背景颜色，默认为app 主色调
     - parameter hidden:    是隐藏还是
     - parameter anmaiter:  需不需要动画显示
     */
    private func messageHandleMethod(message:String = "",backColor:UIColor=UIColor.a_color2,hidden:Bool = false,anmaiter:Bool = true){
        
        if self.timer.valid { self.timer.invalidate() }
        
        self.messageLabel.text = message
        self.messageLabel.backgroundColor = backColor
        
        let show = CGAffineTransformIdentity // 显示视图
        let hiddent = CGAffineTransformTranslate(self.messageLabel.transform, 0, -self.messageLabel.frame.height) // 隐藏加载视图
        
        UIView.animateWithDuration(anmaiter ? 0.3 : 0) {
            
            self.messageLabel.transform = hidden ? hiddent : show
        }
        
        if hidden {return} // 如果隐藏就不需要再次隐藏了
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: #selector(NewFeedListViewController.hiddenTips(_:)), userInfo: nil, repeats: false)
    }
    
    /**
     隐藏提示条的方法，会被时间定时器调用
     
     - parameter timer: 定时器对象
     */
    func hiddenTips(timer:NSTimer){
        
        let hiddent = CGAffineTransformTranslate(self.messageLabel.transform, 0, -self.messageLabel.frame.height) // 隐藏加载视图
        
        UIView.animateWithDuration(0.5, animations: {
            
            self.messageLabel.transform = hiddent
        })
    }
}