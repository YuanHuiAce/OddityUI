//
//  DetailAndCommitViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/21.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip


let CLICKTOCOMMENTVIEWCONTROLLER = "CLICKTOCOMMENTVIEWCONTROLLER" // 用户点击想要去评论视图

@objc protocol PreViewControllerDelegate {
    @objc optional func NoCollectionAction(_ new:New) // 开始
}

open class DetailAndCommitViewController:ButtonBarPagerTabStripViewController,UINavigationControllerDelegate,UIViewControllerTransitioningDelegate,WaitLoadProtcol{

    var predelegate: PreViewControllerDelegate!
    
    //MARK: 收藏相关
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    //MARK: 正常浏览
    var new:New? // 新闻
    
    @IBOutlet var topClickView:UIView!

    @IBOutlet var commentsLabel: UILabel! // 评论数目
    @IBOutlet var CommentAndPostButton: UIButton! // 评论和原文
    @IBOutlet weak var titleLabel: UILabel! // 标题Label
    
    @IBOutlet var dissButton: UIButton! // 左上角更多按钮

    
    @IBOutlet var CommentButtonBackView:UIView!
    @IBOutlet var CommentButtonLeftSpace: NSLayoutConstraint!
    
    fileprivate var commitViewController:CommitViewController!
    fileprivate var detailViewController:DetailViewController!
    
//    var normalResults:Results<Comment>!
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    override open func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.containerView.bounces = false
        self.buttonBarView.isHidden = true
        self.titleLabel.text = self.title
        
        self.containerView.panGestureRecognizer.addTarget(self, action: #selector(DetailAndCommitViewController.pan(_:))) // 添加一个视图
        
//        if let n = new { // 刷新最热评论 和 普通评论
//            CommentUtil.LoadNoramlCommentsList(n)
//            AboutUtil.getAboutListArrayData(n)
//        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailAndCommitViewController.getToCommitViewControllerNotification(_:)), name: NSNotification.Name(rawValue: CLICKTOCOMMENTVIEWCONTROLLER), object: nil) // 当评论页面的查看更多的评论的按钮被评论的消息机制
        /**
         *  用户点击 滑动到顶端视图
         */
        self.topClickView.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            if self.currentIndex == 0 {
            
                self.detailViewController.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
           
            if self.currentIndex == 1 {
                
                self.commitViewController.tableView.setContentOffset(CGPoint.zero, animated: true)
            }
        }))
    }
    
    // 获取到了评论视图的请求了
    func getToCommitViewControllerNotification(_ notification:Foundation.Notification){
        self.moveToViewController(at: 1, animated: true)
    }
    
    open override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        detailViewController = OddityViewControllerManager.shareManager.getDetailViewController(new) // 获得详情视图
        commitViewController = OddityViewControllerManager.shareManager.getCommitViewController(new) // 获取评论视图
        
        self.detailViewController.ShowF = self
        
        return [detailViewController,commitViewController]
    }
    
    /**
     当分页主页 包含 《详情页》& 《评论页》 ，有滑动的时候。进行针对于 评论按钮和去原文按钮的位置变化。
     
     - parameter pagerTabStripViewController: 当前分页视图
     - parameter fromIndex:                   来自 视图的 Index
     - parameter toIndex:                     去往 视图的 Index
     - parameter progressPercentage:          在这段路程中的 progress
     - parameter indexWasChanged:             是否 Index 已经发生了变化
     */
    open override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        if fromIndex == toIndex {
            
            self.setCButton()
            
            return self.ButtonMethod()
        }
        
        if fromIndex == 0 { // 如果来自于 查看详情页面 那么进行必要的修改
            
            self.CommentButtonLeftSpace.constant = -(self.CommentButtonBackView.frame.width)*progressPercentage
        }else{
            
            self.CommentButtonLeftSpace.constant = -(self.CommentButtonBackView.frame.width)*(1-progressPercentage)
        }
        
        self.view.layoutIfNeeded()
    }
}

extension DetailAndCommitViewController{


    
    /**
     点击评论按钮
     
     - parameter sender: <#sender description#>
     */
    @IBAction func touchCommentButton(_ sender: AnyObject) {
        
        self.moveToViewController(at: 1, animated: true)
        
        self.ButtonMethod()
    }
    
    /**
     点击查看原文按钮
     
     - parameter sender: <#sender description#>
     */
    @IBAction func touchPostButton(_ sender: AnyObject) {
        
        self.moveToViewController(at: 0, animated: true)
        
        self.ButtonMethod()
    }
    
    /**
     按钮设置
     
     根据不同的CurrentIndex 设置 按钮的位置，进行相对应的开发
     */
    fileprivate func ButtonMethod(){
        
        self.CommentButtonLeftSpace.constant = self.currentIndex == 0 ? 0 : -self.CommentButtonBackView.frame.width
        
        self.view.layoutIfNeeded()
    }
    
    /**
     设置评论按钮
     */
    func setCButton(){
        
        self.commentsLabel.clipsToBounds = true
        self.commentsLabel.layer.borderColor = UIColor.white.cgColor
        self.commentsLabel.layer.borderWidth = 1.5
        self.commentsLabel.layer.cornerRadius = 3
        self.commentsLabel.text = new == nil ? " 0 " : " \(new!.comment) "
        self.commentsLabel.isHidden = (new == nil || (new?.comment) ?? 0 == 0)
        
        let image = (new == nil || (new?.comment) ?? 0 == 0) ? UIImage.OddityImageByName("详情页未评论") : UIImage.OddityImageByName("详情页已评论")
        
        self.CommentAndPostButton.setImage(image, for: UIControlState())
    }
}
