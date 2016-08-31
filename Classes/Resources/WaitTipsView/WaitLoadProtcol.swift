//
//  WaitLoadProtcol.swift
//  Journalism
//
//  Created by Mister on 16/6/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//


import UIKit
import SnapKit

protocol WaitLoadProtcol {}
extension WaitLoadProtcol where Self:UIViewController{

    // 显示完成删除不感兴趣的新闻
    func showNoInterest(imgName:String = "About",title:String="将减少此类推荐",height:CGFloat = 59,width:CGFloat = 178){
        
        let shareNoInterest = NoInterestView(frame: CGRectZero)
        shareNoInterest.alpha = 1
        self.view.addSubview(shareNoInterest)
        
        shareNoInterest.imageView.image = UIImage(named: imgName)
        shareNoInterest.label.text = title

        shareNoInterest.snp_makeConstraints { (make) in
            
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.center.equalTo(self.view.snp_center)
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(1 * Double(NSEC_PER_SEC))),dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.5, animations: { 
                shareNoInterest.alpha = 0
                }, completion: { (_) in
                    shareNoInterest.removeFromSuperview()
            })
        })
    }
    

}



extension WaitLoadProtcol where Self:NewFeedListViewController{
    

    // 显示等待视图
    func showWaitLoadView(){
        
        if self.waitView == nil {
            
            self.waitView = WaitView.shareWaitView
        }
        
        self.view.addSubview(self.waitView )
        
        self.waitView .snp_makeConstraints { (make) in
            
            make.topMargin.equalTo(self.view.snp_top).offset(0)
            make.bottomMargin.equalTo(self.view.snp_bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp_left).offset(0)
            make.rightMargin.equalTo(self.view.snp_right).offset(0)
        }
    }
    
    // 隐藏等待视图
    func hiddenWaitLoadView(){
        
        if self.waitView != nil {
            
            self.waitView.removeFromSuperview()
            self.waitView = nil
        }
    }
}

extension WaitLoadProtcol where Self:DetailViewController{
    
    
    // 显示等待视图
    func showWaitLoadView(){
        
        if self.waitView == nil {
            
            self.waitView = WaitView.shareWaitView
        }
        
        self.view.addSubview(self.waitView )
        
        self.waitView .snp_makeConstraints { (make) in
            
            make.topMargin.equalTo(self.view.snp_top).offset(0)
            make.bottomMargin.equalTo(self.view.snp_bottom).offset(0)
            make.leftMargin.equalTo(self.view.snp_left).offset(0)
            make.rightMargin.equalTo(self.view.snp_right).offset(0)
        }
    }
    
    // 隐藏等待视图
    func hiddenWaitLoadView(){
        
        if self.waitView != nil {
            
            self.waitView.removeFromSuperview()
            self.waitView = nil
        }
    }
}

