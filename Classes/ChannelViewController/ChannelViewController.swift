//
//  ChannelViewController.swift
//  OddityUI
//
//  Created by Mister on 16/8/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift


private extension Channel{
    
    /**
     根据提供的筛选条件进行数据的获取
     
     - parameter filters: 筛选条件
     
     - returns: 返回 数据
     */
    class func ChannelArray() -> Results<Channel>{
        let realm = try! Realm()
        return realm.objects(Channel.self).sorted(byProperty: "orderindex")
    }
    
    /**
     修改 频道的 排序 属性
     
     - parameter orderindex: 要改变成为的 排序 顺序
     */
    func nChangeOrderIndex(_ orderindex:Int){
        let realm = try! Realm()
        if self.orderindex == orderindex { return }
        try! realm.write { self.orderindex = orderindex }
    }
}




open class ChannelViewController: UIViewController {
    
    let allChannelArray = Channel.ChannelArray() // 全部的频道列表
    let delChannelArray = Channel.DeletedChannelArray()
    let norChannelArray = Channel.NormalChannelArray()
    
    //MARK: 收藏相关
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    fileprivate var allNotificationToken:NotificationToken!
    fileprivate var delNotificationToken:NotificationToken!
    fileprivate var norNotificationToken:NotificationToken!
    
    
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    @IBOutlet var collectionView:UICollectionView!
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
        
        self.modalPresentationCapturesStatusBarAppearance = false
//        self.modalPresentationStyle = UIModalPresentationStyle.Custom
    }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()

        if let layout = self.collectionView.collectionViewLayout as? KDRearrangeableCollectionViewFlowLayout {
        
            layout.delegate = self
        }
        
        collectionView.panGestureRecognizer.require(toFail: pan)
        
        pan.delegate = self
    }
}


extension ChannelViewController : UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate{

    @IBAction func cancelDismiss(_ anyObject: AnyObject) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = pan.translation(in: view)
        
        return fabs(point.x) > fabs(point.y)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
    
    @IBAction func panAction(_ pan: UIPanGestureRecognizer) {
        
        guard let view = pan.view else{return}
        
        let point = pan.translation(in: view)
        
        if pan.state == UIGestureRecognizerState.began {
            
            if point.x < 0 {return}
            
            self.DismissedAnimation.isInteraction = true
            
            self.dismiss(animated: true, completion: nil)
            
        }else if pan.state == UIGestureRecognizerState.changed {
            
            let process = point.x/UIScreen.main.bounds.width
            
            self.InteractiveTransitioning.update(process)
            
        }else {
            
            self.DismissedAnimation.isInteraction = false
            
            let loctionX = abs(Int(point.x))
            
            let velocityX = pan.velocity(in: pan.view).x
            
            if velocityX >= 800 || loctionX >= Int(UIScreen.main.bounds.width/2) {
                
                self.InteractiveTransitioning.finish()
                
            }else{
                
                self.InteractiveTransitioning.cancel()
            }
        }
    }
}

extension ChannelViewController : KDRearrangeableCollectionViewDelegate {

    func moveDataItem(_ fromIndexPath: IndexPath, toIndexPath: IndexPath) {
        
        let realm = try! Realm()
        
        try! realm.write {
            
            if (fromIndexPath as NSIndexPath).item < (toIndexPath as NSIndexPath).item {
            
                let fromChannel = norChannelArray[(fromIndexPath as NSIndexPath).item]
                
                for chan in self.norChannelArray.filter("orderindex > %@ && orderindex <= %@ ", min((fromIndexPath as NSIndexPath).item,(toIndexPath as NSIndexPath).item),max((fromIndexPath as NSIndexPath).item,(toIndexPath as NSIndexPath).item)) {
                    
                    chan.orderindex = chan.orderindex - 1
                }
                
                fromChannel.orderindex = (toIndexPath as NSIndexPath).item
            }
            
            if (fromIndexPath as NSIndexPath).item > (toIndexPath as NSIndexPath).item {
                
                let fromChannel = norChannelArray[(fromIndexPath as NSIndexPath).item]
                
                for chan in self.norChannelArray.filter("orderindex >= %@ && orderindex < %@ ", min((fromIndexPath as NSIndexPath).item,(toIndexPath as NSIndexPath).item),max((fromIndexPath as NSIndexPath).item,(toIndexPath as NSIndexPath).item)) {
                    
                    chan.orderindex = chan.orderindex + 1
                }
                
                fromChannel.orderindex = (toIndexPath as NSIndexPath).item
            }
        }
    }
}

extension ChannelViewController :UICollectionViewDelegate{

    fileprivate func getChannelByIndexPath(_ indexPath: IndexPath) -> Channel{
    
        if (indexPath as NSIndexPath).section == 0 {
            
            return self.norChannelArray[(indexPath as NSIndexPath).item]
        }else {
            
            return self.delChannelArray[(indexPath as NSIndexPath).item]
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).item == 0 && (indexPath as NSIndexPath).section == 0 {return}
        
        self.collectionView.isUserInteractionEnabled = false
        
        let channel = self.getChannelByIndexPath(indexPath)

        let realm = try! Realm()
        
        var toIndexPath:IndexPath!
        
        if (indexPath as NSIndexPath).section == 0 {
        
            try! realm.write {
                
                if (indexPath as NSIndexPath).item+1 != norChannelArray.count {
                
                    for chan in self.norChannelArray[(indexPath as NSIndexPath).item+1...norChannelArray.count-1] {
                        
                        chan.orderindex = chan.orderindex-1
                    }
                }
                
                channel.isdelete = 1
                channel.orderindex = delChannelArray.count
            }
            
            toIndexPath = IndexPath(item: self.delChannelArray.count-1, section: 1)
        }
        
        if (indexPath as NSIndexPath).section == 1 {
            
            try! realm.write {

                channel.isdelete = 0
                channel.orderindex = norChannelArray.count
            }
            
            toIndexPath = IndexPath(item: self.norChannelArray.count-1, section: 0)
        }
        
        self.collectionView.performBatchUpdates({
            
            collectionView.moveItem(at: indexPath, to: toIndexPath ) // 动画完成这个操作
            
        }) { (_) in
            
            self.collectionView.reloadData()
            self.collectionView.isUserInteractionEnabled = true
        }
    }
}

extension ChannelViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 0 ? self.norChannelArray.count : self.delChannelArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
        
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "reusable", for: indexPath) as! ChannelReusableView
            
            reusableView.descLabel.text = (indexPath as NSIndexPath).section == 0 ? "我的频道（拖动调整顺序）" : "热门频道 （点击添加更多）"
            
            return reusableView
        }
        
        return UICollectionReusableView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChannelCollectionViewCell
        
        let channel = self.getChannelByIndexPath(indexPath)
        
        channel.nChangeOrderIndex((indexPath as NSIndexPath).item)
        
        cell.setChannel(channel)
        
        cell.channelNameLabel.font = UIFont.a_font3_3
        
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let scSize = UIScreen.main.bounds
        
        return CGSize(width: (min(scSize.width, scSize.height)-18*2-12*2)/3, height: 35)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
    
        return UIEdgeInsets(top: 26, left: 12, bottom: 26, right: 12)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
    
        return 18
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
    
        return CGSize(width: 0, height: section == 0 ? 42 : 42+9)
    }
}
