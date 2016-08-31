//
//  NoInterestView.swift
//  Journalism
//
//  Created by Mister on 16/6/15.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit

class NoInterestView: UIView {
    
    lazy var label = UILabel()
    lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.imageView.image = UIImage(named: "About")
        self.addSubview(imageView)
        
        imageView.snp_makeConstraints { (make) in
            
            make.centerY.equalTo(self.snp_centerY)
            make.leftMargin.equalTo(20)
        }
        
        label.text = "将减少此类推荐"
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        
        self.addSubview(label)
        
        label.snp_makeConstraints { (make) in
            
            make.centerY.equalTo(self.snp_centerY)
            make.leftMargin.equalTo(self.imageView.snp_right).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 获取单例模式下的UIStoryBoard对象
    class var shareNoInterest:NoInterestView!{
        
        get{
            
            struct backTaskLeton{
                
                static var predicate:dispatch_once_t = 0
                
                static var bgTask:NoInterestView? = nil
            }
            
            dispatch_once(&backTaskLeton.predicate, { () -> Void in
                
                backTaskLeton.bgTask = NoInterestView(frame: CGRectZero)
            })
            
            return backTaskLeton.bgTask
        }
    }
}