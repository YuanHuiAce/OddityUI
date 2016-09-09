//
//  NewBaseTableViewCell.swift
//  Journalism
//
//  Created by Mister on 16/5/19.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import PINRemoteImage

class PButtton:UIButton{
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        
        var bounds = self.bounds
        
        bounds.size = CGSize(width: 44, height: 44)
        
        return CGRectContainsPoint(bounds, point)
    }
}


extension NSURL{
    
    func proPic(q:Int = 60) -> NSURL?{
        
        var urlStr = NSString(string: self.absoluteString+"@1e_1c_0o_0l_100sh_225h_300w_\(q)q.jpeg")
        
        if urlStr.containsString("bdp-pic.deeporiginalx.com/") {
            
            urlStr = urlStr.stringByReplacingOccurrencesOfString("bdp-pic.deeporiginalx.com/", withString: "pro-pic.deeporiginalx.com/")
        }
        
        guard let url = NSURL(string: urlStr as String) else {return nil}
        
        return url
    }
}

import SnapKit

class UILabelPadding : UILabel {
    
    private var padding = UIEdgeInsetsZero
    
    @IBInspectable
    var paddingLeft: CGFloat {
        get { return padding.left }
        set { padding.left = newValue }
    }
    
    @IBInspectable
    var paddingRight: CGFloat {
        get { return padding.right }
        set { padding.right = newValue }
    }
    
    @IBInspectable
    var paddingTop: CGFloat {
        get { return padding.top }
        set { padding.top = newValue }
    }
    
    @IBInspectable
    var paddingBottom: CGFloat {
        get { return padding.bottom }
        set { padding.bottom = newValue }
    }
    
    override func drawTextInRect(rect: CGRect) {
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, padding))
    }
    
    override func textRectForBounds(bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = self.padding
        var rect = super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, insets), limitedToNumberOfLines: numberOfLines)
        rect.origin.x    -= insets.left
        rect.origin.y    -= insets.top
        rect.size.width  += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
}

class NewBaseTableViewCell: UITableViewCell {
    
    
    var viewControllerPreviewing:UIViewControllerPreviewing?
    
    @IBOutlet var timeLabel: UILabel! // 标题 label 控件
    @IBOutlet var titleLabel: UILabel! // 标题 label 控件
    @IBOutlet var pubLabel: UILabel! // 来源 和时间 label控件
    @IBOutlet var noLikeButton: UIButton! // 不喜欢 button 控件
    @IBOutlet var commentCountLabel: UILabel! // 评论 label 控件
    
    let Taglabel = UILabelPadding()
    let JiaPublabel = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.Taglabel.paddingLeft = 2
        self.Taglabel.paddingRight = 2
        self.Taglabel.font = UIFont.a_font7
        self.Taglabel.textAlignment = .Center
        
        self.addSubview(JiaPublabel)
        self.addSubview(Taglabel)
    }
    
    func setPPPLabel(new:New){
        
        self.Taglabel.layer.borderWidth = 0.5
        self.Taglabel.layer.cornerRadius = 2
        
        self.Taglabel.font = UIFont.a_font7
        self.JiaPublabel.font = UIFont.a_font7
        self.JiaPublabel.textColor = UIColor.a_color4
        
        if new.rtype == 1 {
            
            self.Taglabel.text = "热点"
            self.Taglabel.textColor = UIColor.hexStringToColor("#f83b3b")
            self.Taglabel.layer.borderColor = UIColor.hexStringToColor("#f83b3b").CGColor
        }
        
        if new.rtype == 2 {
            
            self.Taglabel.text = "推送"
            self.Taglabel.textColor = UIColor.hexStringToColor("#0091fa")
            self.Taglabel.layer.borderColor = UIColor.hexStringToColor("#0091fa").CGColor
            
        }
        
        self.JiaPublabel.text = self.pubLabel.text
        
        if new.rtype == 0 {
            
            self.pubLabel.hidden = false
            self.JiaPublabel.hidden = true
            self.Taglabel.hidden = true
        }else{
            
            self.pubLabel.hidden = true
            self.JiaPublabel.hidden = false
            self.Taglabel.hidden = false
        }
    }
    
    func setNewObject(new:New,bigImg:Int = -1){
        
        timeLabel.font = UIFont.a_font7
        titleLabel.font = UIFont.a_font2
        pubLabel.font = UIFont.a_font7
        commentCountLabel.font = UIFont.a_font7
        
        
        self.titleLabel.text = new.title
        self.pubLabel.text = new.pname
        self.commentCountLabel.text = "\(new.comment)评"
//        self.timeLabel.text = new.ptimes.weiboTimeDescription
        self.commentCountLabel.hidden = new.comment > 0 ? false : true
        self.titleLabel.textColor = new.isread == 1 ? UIColor.a_color4 : UIColor.a_color3
    }
    
    override func drawRect(rect: CGRect) {

        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        //下分割线
        CGContextSetStrokeColorWithColor(context, UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(0, rect.height, rect.width, 1));
        
        self.Taglabel.snp_makeConstraints { (make) in
            
            make.left.equalTo(12)
            make.centerY.equalTo(self.pubLabel)
        }
        
        self.JiaPublabel.snp_makeConstraints { (make) in
            
            make.centerY.equalTo(self.Taglabel)
            make.left.equalTo(self.Taglabel.snp_right).offset(6)
        }
    }
}

class NewNormalTableViewCell: NewBaseTableViewCell {
    
    override func setNewObject(new:New,bigImg:Int = -1){
        
        super.setNewObject(new)
    }
}

class NewOneTableViewCell: NewBaseTableViewCell {
    
    @IBOutlet var imageView1: UIImageView!
    
    override func setNewObject(new:New,bigImg:Int = -1){
        
        super.setNewObject(new)

        if let url = NSURL(string: new.imgsList[0].value) {
            
            imageView1.pin_setImageFromURL(url.proPic() ?? url, placeholderImage: UIImage.sharePlaceholderImage)
        }
    }
}

class NewTwoTableViewCell: NewBaseTableViewCell {
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    
    lazy var imageView6 = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.imageView6.clipsToBounds = true
        self.imageView6.contentMode = .ScaleAspectFill
        
        self.addSubview(self.imageView6)
    }
    
    override func setNewObject(new:New,bigImg:Int = -1){
        
        super.setNewObject(new)
        
        if bigImg >= 0{
            
            
            self.imageView6.hidden = false
            self.imageView1.hidden = true
            self.imageView2.hidden = true
            
            if let url = NSURL(string: new.imgsList[bigImg].value) {
                
                imageView6.pin_setImageFromURL(url, placeholderImage: UIImage.sharePlaceholderImage)
            }
            
            return
        }
        
        
        self.imageView6.hidden = true
//        self.imageView1.pin_updateWithProgress = true
//        self.imageView2.pin_updateWithProgress = true
//        
        if let url = NSURL(string: new.imgsList[0].value) {
            
            imageView1.pin_setImageFromURL(url.proPic() ?? url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
        if let url = NSURL(string: new.imgsList[1].value) {
            
            imageView2.pin_setImageFromURL(url.proPic() ?? url, placeholderImage: UIImage.sharePlaceholderImage)
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        self.imageView6.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.titleLabel.snp_bottom).offset(7)
            make.bottom.equalTo(self.pubLabel.snp_top).offset(-9)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
    }
}

class NewThreeTableViewCell: NewBaseTableViewCell {
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    
    
    override func setNewObject(new:New,bigImg:Int = -1){
        
        super.setNewObject(new)
        
//        self.imageView1.pin_updateWithProgress = true
//        self.imageView2.pin_updateWithProgress = true
//        self.imageView3.pin_updateWithProgress = true
//        
        if let url = NSURL(string: new.imgsList[0].value) {
            
            imageView1.pin_setImageFromURL(url.proPic() ?? url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
        if let url = NSURL(string: new.imgsList[1].value) {
            
            imageView2.pin_setImageFromURL(url.proPic() ?? url, placeholderImage: UIImage.sharePlaceholderImage)
        }
        
        if let url = NSURL(string: new.imgsList[2].value) {
            
            imageView3.pin_setImageFromURL(url.proPic() ?? url, placeholderImage: UIImage.sharePlaceholderImage)
        }
    }
}