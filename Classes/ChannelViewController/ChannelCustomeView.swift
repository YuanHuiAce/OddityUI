//
//  ChannelCustomeView.swift
//  OddityUI
//
//  Created by Mister on 16/8/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class ChannelCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var channelNameLabel:UILabel!
    @IBOutlet var channelBackView:UIView!
    @IBOutlet var channelStateImageView:UIImageView!
    
    func setChannel(_ channel:Channel){
        
        self.channelBackView.backgroundColor = channel.id == 1 ? UIColor.hexStringToColor("#f6f6f6") : UIColor.white
        
        self.channelNameLabel.textColor = channel.id == 1 ? UIColor.a_color4 : UIColor.black
        self.channelNameLabel.text = channel.cname
        self.channelStateImageView.isHidden = channel.id == 1
        self.channelStateImageView.image = channel.isdelete == 0 ? UIImage.OddityImageByName("delete") : UIImage.OddityImageByName("add")
    }
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        self.clipsToBounds = false
        
        self.channelBackView.clipsToBounds = true
        self.channelBackView.layer.borderWidth = 1
        self.channelBackView.layer.borderColor = UIColor.hexStringToColor("#e5e5e5").cgColor
        self.channelBackView.layer.cornerRadius = 8
    }
}



class ChannelReusableView: UICollectionReusableView {
    
    @IBOutlet var descLabel:UILabel!
    
    var topBorder = UIView()
    var bottomBorder = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        topBorder.backgroundColor = UIColor.hexStringToColor("#c0c0c0").withAlphaComponent(0.3)
        bottomBorder.backgroundColor = UIColor.hexStringToColor("#c0c0c0").withAlphaComponent(0.3)
        
        self.addSubview(topBorder)
        self.addSubview(bottomBorder)
        
        self.backgroundColor = UIColor.clear
        
        topBorder.snp_makeConstraints { (make) in
            
            make.top.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(0.3)
        }
        
        bottomBorder.snp_makeConstraints { (make) in
            
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(0.3)
        }
    }
    
    
//    override func drawRect(rect: CGRect) {
//        super.drawRect(rect)
//        
//        let context = UIGraphicsGetCurrentContext() // 获取绘画板
//        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
//        CGContextFillRect(context, rect)
//        //下分割线
//        CGContextSetStrokeColorWithColor(context, UIColor.hexStringToColor("#c0c0c0").colorWithAlphaComponent(0.3).CGColor)
//        CGContextStrokeRect(context, CGRectMake(0, rect.height, rect.width, 0.5));
//        
//        //上分割线
//        CGContextSetStrokeColorWithColor(context, UIColor.hexStringToColor("#c0c0c0").colorWithAlphaComponent(0.3).CGColor)
//        CGContextStrokeRect(context, CGRectMake(0, -0.5, rect.width, 0.5));
//    }
}


class bottomBorder: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor.hexStringToColor("#c0c0c0").withAlphaComponent(0.3).cgColor)
        context?.stroke(CGRect(x: 0, y: rect.height, width: rect.width, height: 0.5))
    }
}

class topAndBottomBorder: UIView {

    var bottomBorder = UIView()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        bottomBorder.backgroundColor = UIColor.hexStringToColor("#c0c0c0").withAlphaComponent(0.3)
        
        self.addSubview(bottomBorder)

        self.backgroundColor = UIColor.clear

        bottomBorder.snp_makeConstraints { (make) in
            
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.left.equalTo(0)
            make.height.equalTo(0.3)
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        
//        let context = UIGraphicsGetCurrentContext() // 获取绘画板
//        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
//        CGContextFillRect(context, rect)
//        //上分割线
//        CGContextSetStrokeColorWithColor(context, UIColor.hexStringToColor("#c0c0c0").colorWithAlphaComponent(0.3).CGColor)
//        CGContextStrokeRect(context, CGRectMake(0, -0.5, rect.width, 0.5));
//        //下分割线
//        CGContextSetStrokeColorWithColor(context, UIColor.hexStringToColor("#c0c0c0").colorWithAlphaComponent(0.3).CGColor)
//        CGContextStrokeRect(context, CGRectMake(0, rect.height, rect.width, 0.5))
    }
}
