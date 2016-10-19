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
    func showNoInterest(_ imgName:String = "About",title:String="将减少此类推荐",height:CGFloat = 59,width:CGFloat = 178){
        
        let shareNoInterest = NoInterestView(frame: CGRect.zero)
        shareNoInterest.alpha = 1
        self.view.addSubview(shareNoInterest)
        
        shareNoInterest.imageView.image = UIImage.OddityImageByName(imgName)
        shareNoInterest.label.text = title

        shareNoInterest.snp_makeConstraints { (make) in
            
            make.height.equalTo(height)
            make.width.equalTo(width)
            make.center.equalTo(self.view.snp_center)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            UIView.animate(withDuration: 0.5, animations: { 
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
        
        self.waitView.snp.makeConstraints { (make) in
            
            make.margins.equalTo(UIEdgeInsets.zero)
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
        
        self.waitView.snp.makeConstraints { (make) in
            
            make.margins.equalTo(UIEdgeInsets.zero)
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

