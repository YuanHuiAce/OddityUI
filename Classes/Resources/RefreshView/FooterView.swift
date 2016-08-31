//
//  FooterView.swift
//  Journalism
//
//  Created by Mister on 16/6/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import MJRefresh
import SnapKit



class NewRefreshFooterView: MJRefreshAutoFooter {
    
    let loadMoreAnimationKey = "loadMoreRotation"
    
    let labelWidth:CGFloat = 160
    let imageViewWidth:CGFloat = 14
    let imageViewHeitht:CGFloat = 14
    let loadMoreHeight:CGFloat = 40
    
    var view:UIView!
    var label:UILabel!
    var imageView:UIImageView!
    var animation:CABasicAnimation!
    
    override func prepare() {
        
        super.prepare()
        
        self.mj_h = 50
        
        let view = UIView()
        
        let label = UILabel()
        label.textColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
        label.font = UIFont.boldSystemFontOfSize(14)
        label.textAlignment = .Center
        view.addSubview(label)
        self.label = label
        
        let imageView = UIImageView(image: UIImage.OddityImageByName("加载更多"))
        imageView.contentMode = .ScaleAspectFit
        view.addSubview(imageView)
        self.imageView = imageView
        
        let animation = CABasicAnimation(keyPath: "transform")
        animation.repeatCount = FLT_MAX
        animation.duration = 0.2
        animation.cumulative = true
        animation.toValue = NSValue(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI/2), 0, 0, 1))
        self.animation = animation
        
        self.view = view
        
        self.view.addSubview(self.label)
        self.view.addSubview(self.imageView)
        
        self.addSubview(self.view)
    }
    
    override func placeSubviews() {
        
        super.placeSubviews()
        
        self.view.snp_makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.bottom.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        }
        
        self.label.snp_makeConstraints { (make) in
            
            make.center.equalTo(self.view)
        }

        self.imageView.snp_makeConstraints { (make) in
            
            make.centerY.equalTo(self.label)
            make.right.equalTo(self.label.snp_left).offset(-16)
        }
    }
    
    override var state: MJRefreshState{
        
        didSet{
            
            switch state {
            case .Idle:
                self.label.text = ""
                self.imageView.hidden = true
            case .Refreshing:
                self.label.text = "正在载入"
                self.imageView.hidden = false
                self.label.frame = CGRect(x: CGRectGetMaxX(self.imageView.frame)+10, y: 0, width: labelWidth, height: loadMoreHeight)
                self.imageView.layer.addAnimation(self.animation, forKey: loadMoreAnimationKey)
            case .NoMoreData:
                self.label.text = "已显示全部内容"
                self.imageView.hidden = true
                self.label.frame = CGRect(x: CGRectGetMaxX(self.imageView.frame), y: 0, width: labelWidth, height: loadMoreHeight)
                self.imageView.layer.removeAnimationForKey(loadMoreAnimationKey)
            default:
                break
            }
        }
    }
}

