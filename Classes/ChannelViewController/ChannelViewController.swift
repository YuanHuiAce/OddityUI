//
//  ChannelViewController.swift
//  OddityUI
//
//  Created by Mister on 16/8/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import OddityModal


private extension Channel{
    
    /**
     根据提供的筛选条件进行数据的获取
     
     - parameter filters: 筛选条件
     
     - returns: 返回 数据
     */
    private class func ChannelArray() -> Results<Channel>{
        let realm = try! Realm()
        return realm.objects(Channel).sorted("orderindex")
    }
    
    /**
     修改 频道的 排序 属性
     
     - parameter orderindex: 要改变成为的 排序 顺序
     */
    private func nChangeOrderIndex(orderindex:Int){
        let realm = try! Realm()
        if self.orderindex == orderindex { return }
        try! realm.write { self.orderindex = orderindex }
    }
}




public class ChannelViewController: UIViewController {
    
    let allChannelArray = Channel.ChannelArray() // 全部的频道列表
    let delChannelArray = Channel.DeletedChannelArray()
    let norChannelArray = Channel.NormalChannelArray()
    
    //MARK: 收藏相关
    let DismissedAnimation = CustomViewControllerDismissedAnimation()
    let PresentdAnimation = CustomViewControllerPresentdAnimation()
    let InteractiveTransitioning = UIPercentDrivenInteractiveTransition() // 完成 process 渐进行动画
    
    private var allNotificationToken:NotificationToken!
    private var delNotificationToken:NotificationToken!
    private var norNotificationToken:NotificationToken!
    
    
    @IBOutlet var pan: UIPanGestureRecognizer!
    
    @IBOutlet var collectionView:UICollectionView!
    
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.transitioningDelegate = self
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()

        if let layout = self.collectionView.collectionViewLayout as? KDRearrangeableCollectionViewFlowLayout {
        
            layout.delegate = self
        }
        
        collectionView.panGestureRecognizer.requireGestureRecognizerToFail(pan)
        
        pan.delegate = self
    }
}


extension ChannelViewController : UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate{

    @IBAction func cancelDismiss(anyObject: AnyObject) {
    
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let point = pan.translationInView(view)
        
        return fabs(point.x) > fabs(point.y)
    }
    
    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return PresentdAnimation
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return DismissedAnimation
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if self.DismissedAnimation.isInteraction {
            
            return InteractiveTransitioning
        }
        
        return nil
    }
    
    @IBAction func panAction(pan: UIPanGestureRecognizer) {
        
        guard let view = pan.view else{return}
        
        let point = pan.translationInView(view)
        
        if pan.state == UIGestureRecognizerState.Began {
            
            if point.x < 0 {return}
            
            self.DismissedAnimation.isInteraction = true
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }else if pan.state == UIGestureRecognizerState.Changed {
            
            let process = point.x/UIScreen.mainScreen().bounds.width
            
            self.InteractiveTransitioning.updateInteractiveTransition(process)
            
        }else {
            
            self.DismissedAnimation.isInteraction = false
            
            let loctionX = abs(Int(point.x))
            
            let velocityX = pan.velocityInView(pan.view).x
            
            if velocityX >= 800 || loctionX >= Int(UIScreen.mainScreen().bounds.width/2) {
                
                self.InteractiveTransitioning.finishInteractiveTransition()
                
            }else{
                
                self.InteractiveTransitioning.cancelInteractiveTransition()
            }
        }
    }
}

extension ChannelViewController : KDRearrangeableCollectionViewDelegate {

    func moveDataItem(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        
        let realm = try! Realm()
        
        try! realm.write {
            
            if fromIndexPath.item < toIndexPath.item {
            
                let fromChannel = norChannelArray[fromIndexPath.item]
                
                for chan in self.norChannelArray.filter("orderindex > %@ && orderindex <= %@ ", min(fromIndexPath.item,toIndexPath.item),max(fromIndexPath.item,toIndexPath.item)) {
                    
                    chan.orderindex = chan.orderindex - 1
                }
                
                fromChannel.orderindex = toIndexPath.item
            }
            
            if fromIndexPath.item > toIndexPath.item {
                
                let fromChannel = norChannelArray[fromIndexPath.item]
                
                for chan in self.norChannelArray.filter("orderindex >= %@ && orderindex < %@ ", min(fromIndexPath.item,toIndexPath.item),max(fromIndexPath.item,toIndexPath.item)) {
                    
                    chan.orderindex = chan.orderindex + 1
                }
                
                fromChannel.orderindex = toIndexPath.item
            }
        }
    }
}

extension ChannelViewController :UICollectionViewDelegate{

    private func getChannelByIndexPath(indexPath: NSIndexPath) -> Channel{
    
        if indexPath.section == 0 {
            
            return self.norChannelArray[indexPath.item]
        }else {
            
            return self.delChannelArray[indexPath.item]
        }
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.item == 0 && indexPath.section == 0 {return}
        
        self.collectionView.userInteractionEnabled = false
        
        let channel = self.getChannelByIndexPath(indexPath)

        let realm = try! Realm()
        
        var toIndexPath:NSIndexPath!
        
        if indexPath.section == 0 {
        
            try! realm.write {
                
                if indexPath.item+1 != norChannelArray.count {
                
                    for chan in self.norChannelArray[indexPath.item+1...norChannelArray.count-1] {
                        
                        chan.orderindex = chan.orderindex-1
                    }
                }
                
                channel.isdelete = 1
                channel.orderindex = delChannelArray.count
            }
            
            toIndexPath = NSIndexPath(forItem: self.delChannelArray.count-1, inSection: 1)
        }
        
        if indexPath.section == 1 {
            
            try! realm.write {

                channel.isdelete = 0
                channel.orderindex = norChannelArray.count
            }
            
            toIndexPath = NSIndexPath(forItem: self.norChannelArray.count-1, inSection: 0)
        }
        
        self.collectionView.performBatchUpdates({
            
            collectionView.moveItemAtIndexPath(indexPath, toIndexPath: toIndexPath ) // 动画完成这个操作
            
        }) { (_) in
            
            self.collectionView.reloadData()
            self.collectionView.userInteractionEnabled = true
        }
    }
}

extension ChannelViewController:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{

    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return 2
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 0 ? self.norChannelArray.count : self.delChannelArray.count
    }
    
    public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
        
            let reusableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "reusable", forIndexPath: indexPath) as! ChannelReusableView
            
            reusableView.descLabel.text = indexPath.section == 0 ? "我的频道（拖动调整顺序）" : "热门频道 （点击添加更多）"
            
            return reusableView
        }
        
        return UICollectionReusableView()
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ChannelCollectionViewCell
        
        let channel = self.getChannelByIndexPath(indexPath)
        
        channel.nChangeOrderIndex(indexPath.item)
        
        cell.setChannel(channel)
        
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
    
        return UIEdgeInsets(top: 26, left: 13, bottom: 26, right: 13)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
    
        return 19
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
    
        return 20
    }
    
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
    
        return CGSize(width: 0, height: section == 0 ? 42 : 42+9)
    }
}
