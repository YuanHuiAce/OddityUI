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
import XLPagerTabStrip


open class ChannelsManagerViewController: CircularButtonBarPagerTabStripViewController {
    
    open let odditySetting = OdditySetting()
    open var oddityDelegate:OddityUIDelegate?
    
    // 不喜欢按钮集合
    @IBOutlet var button1: ReasonButton!
    @IBOutlet var button2: ReasonButton!
    @IBOutlet var button3: ReasonButton!
    @IBOutlet var button4: ReasonButton!
    @IBOutlet var noLikeChosseView: UIView!

    @IBOutlet var noLikeChosseViewTopCOnstraint: NSLayoutConstraint!
    
    fileprivate var ChannelBackView:UIView!
    
    fileprivate var notificationToken:NotificationToken!
    fileprivate var cResults:Results<Channel> = Channel.NormalChannelArray()
    
    internal var standardViewControllers = [UIViewController]() // 为了防止重新加载时图，新建一个视图集合库
    internal var reloadViewControllers = [UIViewController]() // buttonBarViewController 数据源对象集合
    
    let shareBackView :UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    override open func viewDidLoad() {
        settings.style.selectedBarHeight = 1.5
        
        super.viewDidLoad()
        
        settings.style.buttonBarItemsShouldFillAvailiableWidth = false
        
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
                
                let viewController = ChannelViewControllerCached.sharedCached.titleForViewController($0,managerViewController: self)
                
                viewController.odditySetting = self.odditySetting
                viewController.oddityDelegate = self.oddityDelegate
                
                return viewController
            }
            
            self.reloadPagerTabStripView()
        }
    }
    
    //MARK: PagerTabStripViewControllerDataSource
    open override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        if self.reloadViewControllers.count <= 0 {
            
            let viewC = NewFeedListViewController()
            
            reloadViewControllers.append(viewC)
        }
        
        return reloadViewControllers
    }
    
    open override func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        super.updateIndicator(for: viewController, fromIndex: fromIndex, toIndex: toIndex, withProgressPercentage: progressPercentage, indexWasChanged: indexWasChanged)
        let oldCell = buttonBarView.cellForItem(at: IndexPath(item: fromIndex, section: 0)) as? ButtonBarViewCell
        let newCell = buttonBarView.cellForItem(at: IndexPath(item: toIndex, section: 0)) as? ButtonBarViewCell
        let oldColor = UIColor.black.withAlphaComponent(0.8)
        let newColor = UIColor.a_color2
        oldCell?.label.textColor = newColor.interpolateRGBColorTo(oldColor, fraction: progressPercentage)
        newCell?.label.textColor = oldColor.interpolateRGBColorTo(newColor, fraction: progressPercentage)
    }
}

public extension ChannelsManagerViewController{

    // 初始化分页视图方法
    fileprivate func initialPagerTabStripMethod(){
        
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: false) // 设置为达到两边后不可以进行再滑动
        
        settings.style.buttonBarMinimumLineSpacing = 1
        settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 15) // 设置显示标题的字体大小
        buttonBarView.backgroundColor = UIColor.white // 设置标题模块的背景颜色
        buttonBarView.selectedBar.backgroundColor = UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 0.3) // 设置选中的barview 的背景颜色
        settings.style.buttonBarItemBackgroundColor = UIColor.clear // 设置ButtonItem 背景颜色
        
        //        self.ChannelManagerContainerCollectionView.scrollsToTop = false
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in // 设置滑动时改编字体
            
            guard changeCurrentIndex == true else { return }
//                        self.ReloadVisCellsSelectedMethod(self.currentIndex) // 刷新这个频道管理的额标题颜色
            //            self.ChannelDataSource.ChannelCurrentIndex = self.currentIndex
            
            oldCell?.label.textColor = UIColor.black.withAlphaComponent(0.8)
            newCell?.label.textColor = UIColor.a_color2
        }
    }
}









extension ChannelsManagerViewController :NewslistViewControllerNoLikeDelegate{
    
    struct WTFFFFF {
        
        static var finish: ((_ cancel: Bool) -> Void)!
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        if !self.noLikeChosseView.isHidden{
            
            self.HideNoLikeHandleViewButton(finish:WTFFFFF.finish)
        }
    }
    
    func ClickNoLikeButtonOfUITableViewCell(_ cell: NewBaseTableViewCell, finish: @escaping ((_ cancel: Bool) -> Void)) {
        
        if !self.noLikeChosseView.isHidden {
            
            self.HideNoLikeHandleViewButton(finish:finish)
        }else{
            
            WTFFFFF.finish = finish
            
            self.ShowNoLikeHandleViewButton(cell,finish:finish)
        }
    }
    
    fileprivate func HideNoLikeHandleViewButton(_ cancel:Bool=true,finish: @escaping ((_ cancel: Bool) -> Void)){
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.noLikeChosseView.alpha = 0
        }) 
        
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.noLikeChosseView.transform = self.noLikeChosseView.transform.translatedBy(x: 0, y: -self.noLikeChosseView.frame.height)
            
        }, completion: { (_) in
            
            self.noLikeChosseView.isHidden = true
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.shareBackView.alpha = 0
                
                }, completion: { (_) in
                    
                    finish(cancel)
            })
        }) 
        
        
    }
    
    fileprivate func ShowNoLikeHandleViewButton(_ cell: NewBaseTableViewCell,finish: @escaping ((_ cancel: Bool) -> Void)){
        
        
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
        self.shareBackView.isHidden = false
        self.view.insertSubview(self.shareBackView, belowSubview: self.noLikeChosseView) // 初始化背景视图
        
        cell.frame = cell.convert(cell.bounds, to: self.view)
        self.view.addSubview(cell) // 添加Cell
        
        self.noLikeChosseViewTopCOnstraint.constant = cell.frame.origin.y+cell.frame.height // 设置显示的约束大笑
        self.view.layoutIfNeeded()
        
        self.button4.setTitle("  来源:\(cell.pubLabel.text!)  ", for: UIControlState())
        self.noLikeChosseView.transform = cell.transform.translatedBy(x: 0, y: -self.noLikeChosseView.frame.height)
        
        self.noLikeChosseView.alpha = 0
        self.noLikeChosseView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.shareBackView.alpha = 1
            
        }, completion: { (_) in
            
            UIView.animate(withDuration: 0.3, animations: {
                
                self.noLikeChosseView.transform = CGAffineTransform.identity
            }) 
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.noLikeChosseView.alpha = 1
            })
        }) 
    }
    
    @IBAction func ClickManager(_ sender: AnyObject) {
        
        let viewController = OddityViewControllerManager.shareManager.getChannelViewController()
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func ClickNoLikeButton(_ sender: AnyObject) {
        
        self.HideNoLikeHandleViewButton(false,finish:WTFFFFF.finish)
    }
}


///  原因按钮
class ReasonButton:UIButton {
    
    var clickSelected = false{
        
        didSet{
            
            self.layer.borderColor = clickSelected ? UIColor.red.withAlphaComponent(0.7).cgColor : UIColor.lightGray.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        self.clickSelected = !clickSelected
    }
}
