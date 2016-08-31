//
//  ChannelsManagerViewController.swift
//  OddityUI
//
//  Created by Mister on 16/8/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit
import RealmSwift
import OddityModal
import XLPagerTabStrip

public class ChannelsManagerViewController: CircularButtonBarPagerTabStripViewController {
    
    // 不喜欢按钮集合
    @IBOutlet var button1: ReasonButton!
    @IBOutlet var button2: ReasonButton!
    @IBOutlet var button3: ReasonButton!
    @IBOutlet var button4: ReasonButton!
    @IBOutlet var noLikeChosseView: UIView!

    @IBOutlet var noLikeChosseViewTopCOnstraint: NSLayoutConstraint!
    
    private var ChannelBackView:UIView!
    
    private var notificationToken:NotificationToken!
    private var cResults:Results<Channel> = Channel.NormalChannelArray()
    
    internal var standardViewControllers = [UIViewController]() // 为了防止重新加载时图，新建一个视图集合库
    internal var reloadViewControllers = [UIViewController]() // buttonBarViewController 数据源对象集合
    
    override public func viewDidLoad() {
        
        settings.style.selectedBarHeight = 1.5
        
        super.viewDidLoad()
        
        self.initialPagerTabStripMethod()
        
        /**
         *  刷新频道
         */
        ChannelAPI.nsChsGet()
        /**
         *  当频道数据发生了变化，进行视图的重新排序制作操作
         */
        self.notificationToken = self.cResults.addNotificationBlock { (_) in
            
            self.reloadViewControllers = self.cResults.map{
                
                let viewController = ChannelViewControllerCached.sharedCached.titleForViewController($0)
                
                viewController.delegate = self
                
                return viewController
            }
            
            
            self.reloadPagerTabStripView()
        }
    }
    
    //MARK: PagerTabStripViewControllerDataSource
    override public func viewControllersForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        if self.reloadViewControllers.count <= 0 {
            
            let viewC = NewFeedListViewController()
            
            reloadViewControllers.append(viewC)
        }
        
        return reloadViewControllers
    }
    
    override public func pagerTabStripViewController(pagerTabStripViewController: PagerTabStripViewController, updateIndicatorFromIndex fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.pagerTabStripViewController(pagerTabStripViewController, updateIndicatorFromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        let oldCell = buttonBarView.cellForItemAtIndexPath(NSIndexPath(forItem: fromIndex, inSection: 0)) as? ButtonBarViewCell
        let newCell = buttonBarView.cellForItemAtIndexPath(NSIndexPath(forItem: toIndex, inSection: 0)) as? ButtonBarViewCell
        let oldColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        let newColor = UIColor.a_color2
        oldCell?.label.textColor = newColor.interpolateRGBColorTo(oldColor, fraction: progressPercentage)
        newCell?.label.textColor = oldColor.interpolateRGBColorTo(newColor, fraction: progressPercentage)
    }
}

public extension ChannelsManagerViewController{

    // 初始化分页视图方法
    private func initialPagerTabStripMethod(){
        
        pagerBehaviour = .Progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: false) // 设置为达到两边后不可以进行再滑动
        
        settings.style.buttonBarMinimumLineSpacing = 1
        settings.style.buttonBarItemFont = UIFont.boldSystemFontOfSize(15) // 设置显示标题的字体大小
        buttonBarView.backgroundColor = UIColor.whiteColor() // 设置标题模块的背景颜色
        buttonBarView.selectedBar.backgroundColor = UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 0.3) // 设置选中的barview 的背景颜色
        settings.style.buttonBarItemBackgroundColor = UIColor.clearColor() // 设置ButtonItem 背景颜色
        
        //        self.ChannelManagerContainerCollectionView.scrollsToTop = false
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in // 设置滑动时改编字体
            
            guard changeCurrentIndex == true else { return }
//                        self.ReloadVisCellsSelectedMethod(self.currentIndex) // 刷新这个频道管理的额标题颜色
            //            self.ChannelDataSource.ChannelCurrentIndex = self.currentIndex
            
            oldCell?.label.textColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
            newCell?.label.textColor = UIColor.a_color2
        }
    }
}









extension ChannelsManagerViewController :NewslistViewControllerNoLikeDelegate{
    
    struct WTFFFFF {
        
        static var finish: ((cancel: Bool) -> Void)!
    }
    
    override public func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        if !self.noLikeChosseView.hidden{
            
            self.HideNoLikeHandleViewButton(finish:WTFFFFF.finish)
        }
    }
    
    func ClickNoLikeButtonOfUITableViewCell(cell: NewBaseTableViewCell, finish: ((cancel: Bool) -> Void)) {
        
        if !self.noLikeChosseView.hidden {
            
            self.HideNoLikeHandleViewButton(finish:finish)
        }else{
            
            WTFFFFF.finish = finish
            
            self.ShowNoLikeHandleViewButton(cell,finish:finish)
        }
    }
    
    private func HideNoLikeHandleViewButton(cancel:Bool=true,finish: ((cancel: Bool) -> Void)){
        
        UIView.animateWithDuration(0.2) {
            
            self.noLikeChosseView.alpha = 0
        }
        
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.noLikeChosseView.transform = CGAffineTransformTranslate(self.noLikeChosseView.transform, 0, -self.noLikeChosseView.frame.height)
            
        }) { (_) in
            
            self.noLikeChosseView.hidden = true
            
            UIView.animateWithDuration(0.3, animations: {
                
                self.shareBackView.alpha = 0
                
                }, completion: { (_) in
                    
                    finish(cancel: cancel)
            })
        }
        
        
    }
    
    private func ShowNoLikeHandleViewButton(cell: NewBaseTableViewCell,finish: ((cancel: Bool) -> Void)){
        
        
        let tapCell = UITapGestureRecognizer { (tap) in
            
            cell.removeGestureRecognizer(tap)
            
            self.HideNoLikeHandleViewButton(finish:finish)
        }
        
        cell.addGestureRecognizer(tapCell)
        
        self.shareBackView.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            self.HideNoLikeHandleViewButton(finish:finish)
        }))
        
        
        self.button1.clickSelected = false
        self.button2.clickSelected = false
        self.button3.clickSelected = false
        self.button4.clickSelected = false
        
        self.shareBackView.alpha = 0
        self.shareBackView.hidden = false
        self.view.insertSubview(self.shareBackView, belowSubview: self.noLikeChosseView) // 初始化背景视图
        
        cell.frame = cell.convertRect(cell.bounds, toView: self.view)
        self.view.addSubview(cell) // 添加Cell
        
        self.noLikeChosseViewTopCOnstraint.constant = cell.frame.origin.y+cell.frame.height // 设置显示的约束大笑
        self.view.layoutIfNeeded()
        
        self.button4.setTitle("  来源:\(cell.pubLabel.text!)  ", forState: UIControlState.Normal)
        self.noLikeChosseView.transform = CGAffineTransformTranslate(cell.transform, 0, -self.noLikeChosseView.frame.height)
        
        self.noLikeChosseView.alpha = 0
        self.noLikeChosseView.hidden = false
        
        UIView.animateWithDuration(0.3, animations: {
            
            self.shareBackView.alpha = 1
            
        }) { (_) in
            
            UIView.animateWithDuration(0.3) {
                
                self.noLikeChosseView.transform = CGAffineTransformIdentity
            }
            
            UIView.animateWithDuration(0.5, animations: {
                
                self.noLikeChosseView.alpha = 1
            })
        }
    }
    
    @IBAction func ClickManager(sender: AnyObject) {
        
        let viewController = OddityViewControllerManager.shareManager.getChannelViewController()
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func ClickNoLikeButton(sender: AnyObject) {
        
        self.HideNoLikeHandleViewButton(false,finish:WTFFFFF.finish)
    }
    
    /// 获取一个放置在首页的一个 背景视图
    private var shareBackView:UIView!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:UIView? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = UIView(frame: UIScreen.mainScreen().bounds)
                backTaskLeton.bgTask!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
            })
            
            return backTaskLeton.bgTask
        }
    }
}


///  原因按钮
class ReasonButton:UIButton {
    
    var clickSelected = false{
        
        didSet{
            
            self.layer.borderColor = clickSelected ? UIColor.redColor().colorWithAlphaComponent(0.7).CGColor : UIColor.lightGrayColor().CGColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1
    }
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        
        self.clickSelected = !clickSelected
    }
}
