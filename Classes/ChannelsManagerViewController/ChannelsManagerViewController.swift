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

open class ChannelsManagerViewController: CircularButtonBarPagerTabStripViewController {
    
    open let odditySetting = OdditySetting() // 用户对于SDK的设置
    open var oddityDelegate:OddityUIDelegate? // 用户对Sdk的动作的监测
    
    fileprivate var notificationToken:NotificationToken! // 检测 新闻变化的 通知对象
    fileprivate var cResults:Results<Channel> = Channel.NormalChannelArray() // 当前视图的新闻数据集合
    internal var reloadViewControllers = [UIViewController]() // buttonBarViewController 数据源对象集合
    
    /// 原因选择视图
    fileprivate var chooseView:ChooseView?
    /// 展示当用户点击X号显示的背景View
    fileprivate let shareBackView :UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()
    
    override open func viewDidLoad() {
        
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
        
        self.initStyleMethod()
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

    /// 初始化布局
    fileprivate func initStyleMethod(){
    
        self.view.backgroundColor = UIColor.white
        
        let navView = BottomBoderView()
        navView.clipsToBounds = true
        self.view.insertSubview(navView, belowSubview: self.buttonBarView)
        
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.addAction(events: UIControlEvents.touchUpInside) { (_) in
            
            self.present(OddityViewControllerManager.shareManager.getChannelViewController(), animated: true, completion: nil)
        }
        button.setImage(UIImage.OddityImageByName("添加频道"), for: UIControlState.normal)
        navView.addSubview(button)
        
        navView.snp.makeConstraints { (make) in
            
            make.top.equalTo(20)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(44)
        }
        
        button.snp.makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(-0.5)
            make.width.equalTo(44)
        }
        
        self.buttonBarView.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.right.equalTo(-44)
            make.height.equalTo(43.5)
            make.top.equalTo(20)
        }
        
        self.containerView.snp.makeConstraints { (make) in
            
            make.top.equalTo(navView.snp.bottom)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
    }
    
    // 初始化分页视图方法
    fileprivate func initialPagerTabStripMethod(){
        
        pagerBehaviour = .progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: false) // 设置为达到两边后不可以进行再滑动
        
        settings.style.buttonBarMinimumLineSpacing = 1
        settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 15) // 设置显示标题的字体大小
        buttonBarView.backgroundColor = UIColor.white // 设置标题模块的背景颜色
        buttonBarView.selectedBar.backgroundColor = UIColor(red: 53/255, green:166/255, blue: 251/255, alpha: 0.3) // 设置选中的barview 的背景颜色
        settings.style.buttonBarItemBackgroundColor = UIColor.clear // 设置ButtonItem 背景颜色
        
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in // 设置滑动时改编字体
            
            guard changeCurrentIndex == true else { return }
//                        self.ReloadVisCellsSelectedMethod(self.currentIndex) // 刷新这个频道管理的额标题颜色
            //            self.ChannelDataSource.ChannelCurrentIndex = self.currentIndex
            
            oldCell?.label.textColor = UIColor.black.withAlphaComponent(0.8)
            newCell?.label.textColor = UIColor.a_color2
        }
    }
}









extension ChannelsManagerViewController :NewslistViewControllerNoLikeDelegate ,ChooseDelegate{
    
    
    
    /// 当用户点击 X 号 触发的事件
    func ClickNoLikeButtonOfUITableViewCell(_ cell: NewBaseTableViewCell, finish: @escaping ((_ cancel: Bool) -> Void)) {
        
        if let view = self.chooseView {
        
            self.HideNoLikeHandleViewButton(finish:finish)
        }else{
            
            WTFFFFF.finish = finish
            
            self.ShowNoLikeHandleViewButton(cell,finish:finish)
        }
    }
    
    
    struct WTFFFFF {
        
        static var finish: ((_ cancel: Bool) -> Void)!
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        self.HideNoLikeHandleViewButton(finish:WTFFFFF.finish)
    }
    

    
    fileprivate func HideNoLikeHandleViewButton(_ cancel:Bool=true,finish: @escaping ((_ cancel: Bool) -> Void)){
        
        if let cview = self.chooseView {
        
            UIView.animate(withDuration: 0.2, animations: {
                
                cview.alpha = 0
            })
            
            
            UIView.animate(withDuration: 0.3, animations: {
                
                cview.transform = cview.transform.translatedBy(x: 0, y: -cview.frame.height)
                
                }, completion: { (_) in
                    
                    cview.isHidden = true
                    
                    UIView.animate(withDuration: 0.3, animations: {
                        
                        self.shareBackView.alpha = 0
                        
                        }, completion: { (_) in
                            
                            finish(cancel)
                            
                            self.chooseView?.isHidden = true
                            self.chooseView = nil
                    })
            })
        }
    }
    
    fileprivate func ShowNoLikeHandleViewButton(_ cell: NewBaseTableViewCell,finish: @escaping ((_ cancel: Bool) -> Void)){
        
        
        /// d昂用户点击这个cell 隐藏的同时 清楚该点击事件
        cell.addGestureRecognizer(UITapGestureRecognizer { (tap) in
            
            cell.removeGestureRecognizer(tap)
            
            self.HideNoLikeHandleViewButton(finish:finish)
        })
        
        /// 当用户点击背景图也是如此
        self.shareBackView.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            self.HideNoLikeHandleViewButton(finish:finish)
        }))
        
        let cview = ViewLoader<ChooseView>.View(viewIndex: 0)
        
        cview.delegate = self
        
        cview.button1.clickSelected = false
        cview.button2.clickSelected = false
        cview.button3.clickSelected = false
        cview.button4.clickSelected = false
        
        self.shareBackView.alpha = 0
        self.shareBackView.isHidden = false
        self.view.addSubview(cview)
        self.view.insertSubview(self.shareBackView, belowSubview: cview) // 初始化背景视图
        
        cell.frame = cell.convert(cell.bounds, to: self.view)
        self.view.addSubview(cell) // 添加Cell
        
        cview.snp.updateConstraints { (make) in
            
            make.width.equalTo(self.view)
            make.height.equalTo(128)
            make.left.equalTo(0)
            make.top.equalTo(cell.frame.origin.y+cell.frame.height)
        }
        
        self.view.layoutIfNeeded()
        
        cview.button4.setTitle("  来源:\(cell.pubLabel.text!)  ", for: UIControlState())
        cview.transform = cell.transform.translatedBy(x: 0, y: -cview.frame.height)
        
        cview.alpha = 0
        cview.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.shareBackView.alpha = 1
            
        }, completion: { (_) in
            
            UIView.animate(withDuration: 0.3, animations: {
                
                cview.transform = CGAffineTransform.identity
            }) 
            
            UIView.animate(withDuration: 0.5, animations: {
                
                cview.alpha = 1
            })
        })
        
        self.chooseView = cview
    }
    
    func ClickDisLikeAction() {
        
        self.HideNoLikeHandleViewButton(false,finish:WTFFFFF.finish)
    }
}


