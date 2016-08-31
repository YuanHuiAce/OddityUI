//
//  WaitView.swift
//  Journalism
//
//  Created by Mister on 16/6/15.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit




class WaitView: UIView {
    
    lazy var label = UILabel()
    lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        
        
        let image1 = UIImage.OddityImageByName("xl_1")!
        let image2 = UIImage.OddityImageByName("xl_2")!
        let image3 = UIImage.OddityImageByName("xl_3")!
        let image4 = UIImage.OddityImageByName("xl_4")!
        
        self.imageView.animationImages = [image1,image2,image3,image4]
        self.imageView.animationDuration = 0.6
        self.imageView.startAnimating()
        
        self.addSubview(imageView)
        
        
        label.text = "正在努力加载..."
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        label.textAlignment = .Center
        
        self.addSubview(label)
        
        imageView.snp_makeConstraints { (make) in
            
            make.center.equalTo(self.snp_center)
        }
        
        label.snp_makeConstraints { (make) in
            
            make.centerX.equalTo(self.snp_centerX)
            make.topMargin.equalTo(self.imageView.snp_bottom).offset(20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 获取单例模式下的UIStoryBoard对象
    class var shareWaitView:WaitView!{
        
        get{
            return WaitView(frame: CGRectZero)
        }
    }
    
    /**
     设置无网络情况。
     
     - parameter click: 点击事件
     */
    func setNoNetWork(click:(()->Void)?){
    
        self.imageView.stopAnimating()
        
        self.imageView.image = UIImage(named: "无信号－无信号icon")
        self.label.text = "加载失败，请联网后点击重试"
        self.imageView.userInteractionEnabled = false
        self.label.userInteractionEnabled = false
        
        self.userInteractionEnabled = true
        self.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            
            click?()
        }))
    }
}