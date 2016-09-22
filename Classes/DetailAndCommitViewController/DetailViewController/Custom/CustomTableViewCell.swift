//
//  CustomTableViewCell.swift
//  Journalism
//
//  Created by Mister on 16/5/31.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import PINRemoteImage

extension Date{

    
    /**
     根据当前日期，返回对应的格式描述文字
     
     刚刚(一分钟内)
     X分钟前(一小时内)
     X小时前(当天)
     昨天 HH:mm(昨天)
     MM-dd HH:mm(一年内)
     yyyy-MM-dd HH:mm(更早期)
     */
    var weiboTimeDescription: String {
        
        let canlender = Calendar.current
        // 当天
        if canlender.isDateInToday(self) {
            // 时间差
            let delta = Int(Date().timeIntervalSince(self))
            
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta / 60) 分钟前"
            }
            return "\(delta / 3600) 小时前"
        }
        
        // 往日
        var fmt = " HH:mm"
        
        if canlender.isDateInYesterday(self) {
            fmt = "昨天" + fmt
        } else {
            
            fmt = "MM-dd" + fmt
            // 判断两个日期之间是否有一个完整的`年度`差
            let coms = (canlender as NSCalendar).components(.year, from: self, to: Date(), options: [])
            
            if coms.year != 0 {
                fmt = "yyyy-" + fmt
            }
        }
        // 日期转换
        let df = DateFormatter()
        df.locale = Locale(identifier: "en")
        df.dateFormat = fmt
        
        return df.string(from: self)
    }
}

class CommentsTableViewCell:UITableViewCell{
    
    @IBOutlet var infoLabel: UILabel!
    @IBOutlet var cnameLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var avatarView: UIImageView!
    
    @IBOutlet var praiseLabel: UILabel!
    @IBOutlet var praiseButton: UIButton!
    @IBOutlet var praiseedButton: UIButton!
    
    var comment:Comment!
    var tableView:UITableView!
    var indexPath:IndexPath!
    
    func setCommentMethod(_ comment:Comment,tableView:UITableView,indexPath:IndexPath){
        
        self.comment = comment
        self.tableView = tableView
        self.indexPath = indexPath
        
        praiseLabel.font = UIFont.a_font7
        cnameLabel.font = UIFont.a_font4
        infoLabel.font = UIFont.a_font7
        contentLabel.font = UIFont.a_font3
        
        praiseLabel.isHidden = comment.commend <= 0
        praiseButton.isEnabled = false
        praiseedButton.isEnabled = false
        praiseedButton.isHidden = comment.upflag == 0 // 用户没有点赞隐藏
        
        praiseLabel.text = "\(comment.commend)"
        
        contentLabel.text = comment.content
        infoLabel.text = comment.ctimes.weiboTimeDescription
        cnameLabel.text = comment.uname
        
        if let url = URL(string: comment.avatar) {
            
            avatarView.pin_setImage(from: url, placeholderImage: UIImage.SharePlaceholderImage())
        }
    }

    
    override func draw(_ rect: CGRect) {
        
        self.avatarView.clipsToBounds = true
        self.avatarView.layer.cornerRadius = self.avatarView.frame.height/2
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 18, y: rect.height, width: rect.width - 36, height: 1));
    }
}

class SearchTableViewCell:UITableViewCell{
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 0, y: rect.height, width: rect.width, height: 1));
    }
}

class MoreTableViewCell:UITableViewCell{
    
    
}


extension Comment {
    
    func HeightByNewConstraint(_ tableView:UITableView) -> CGFloat{
        
        let width = tableView.frame.width
        
        // 计算平路内容所占高度
        let contentSize = CGSize(width: width-18-38-12-18, height: CGFloat(MAXFLOAT))
        let contentHeight = NSString(string:self.content).boundingRect(with: contentSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font3], context: nil).height
        
        // time
        let size = CGSize(width: 1000, height: 1000)
        let commentHeight = NSString(string:self.ctimes.weiboTimeDescription).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
        
        // name
        let nameHeight = NSString(string:self.uname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font4], context: nil).height
        
        return 21+21+nameHeight+commentHeight+contentHeight+12+8
    }
}

extension About {
    
    func HeightByNewConstraint(_ tableView:UITableView,hiddenY:Bool) -> CGFloat{
        
        let width = tableView.frame.width
        
        var content:CGFloat = 60
        
        if (self.img?.characters.count)! <= 0  {
            
            let size = CGSize(width: width-17-17-7-7, height: 1000)
            
            content = NSString(string:self.title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
            
            content += NSString(string:self.pname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            content += 10
        }else{
            
            let size = CGSize(width: (width-34-14-81-15), height: 1000)
            
            content = NSString(string:self.title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font2], context: nil).height
            
            content += NSString(string:self.pname).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.a_font7], context: nil).height
            
            content += 10
            
        }
        
        content = hiddenY ? content-21 : content
        
        return 10+21+17+10+7+10+content
    }
}


class circularView:UIView{

    override func draw(_ rect: CGRect) {
    
        self.layer.cornerRadius = rect.height/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor
        self.clipsToBounds = true
    }
}



extension String {
    
    func toAttributedString(_ font:UIFont=UIFont.a_font2) -> NSAttributedString{
        
        return AttributedStringLoader.sharedLoader.imageForUrl(self)
    }
}

/// 属性字符串 缓存器
class AttributedStringLoader {
    
    static let sharedLoader:AttributedStringLoader = {return AttributedStringLoader()}()

    var cache = NSCache<AnyObject,AnyObject>()
    
    /**
     根据提供的String 继而提供 属性字符串
     
     - parameter string: 原本 字符串
     - parameter font:   字体 对象 默认为 系统2号字体
     
     - returns: 返回属性字符串
     */
    func imageForUrl(_ string : String,font:UIFont=UIFont.a_font2) -> NSAttributedString {
        
        if let aString = self.cache.object(forKey: string as AnyObject) as? NSAttributedString { return aString }
        
        let attributed = try! NSMutableAttributedString(data: string.data(using: String.Encoding.unicode)!, options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
        
        attributed.addAttributes([NSFontAttributeName:font], range: NSMakeRange(0, attributed.length))
        
        self.cache.setObject(attributed, forKey: string as AnyObject)
        
        return attributed
    }
}

class AboutTableViewCell:UITableViewCell{

    @IBOutlet var YearLabel: UILabel! // 年份label
    @IBOutlet var MAndDLabel: UILabel! // 月 日 label
    @IBOutlet var contentLabel: UILabel! // 内容Label
    @IBOutlet var descImageView: UIImageView! // 图片视图
    @IBOutlet var pnameLabel: UILabel! // 来源名称
    
    @IBOutlet var descImageWidthConstraint: NSLayoutConstraint! // 图片宽度约束对象
    @IBOutlet var cntentRightSpaceConstraint: NSLayoutConstraint! // 图片宽度约束对象
    @IBOutlet var titleHeadightConstraint: NSLayoutConstraint! // 图片宽度约束对象
    
    var isHeader = false
    var hiddenYear = false
    
    func setAboutMethod(_ about:About,hiddenY:Bool){
    
        self.hiddenYear = hiddenY
        
        
        YearLabel.font = UIFont.a_font8
        MAndDLabel.font = UIFont.a_font8
        contentLabel.font = UIFont.a_font2
        pnameLabel.font = UIFont.a_font7
        
        YearLabel.layer.cornerRadius = 1
        MAndDLabel.layer.cornerRadius = 1
        
        YearLabel.clipsToBounds = true
        MAndDLabel.clipsToBounds = true
        
        let fromStr = about.from.lowercased()
        let yesabout = UIColor(red: 0, green: 145/255, blue: 250/255, alpha: 1)
        let noabout = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)
        
        MAndDLabel.backgroundColor = (fromStr == "baidu" || fromStr == "google") ? yesabout : noabout
        
        pnameLabel.text = about.pname
        YearLabel.text = "\(about.ptimes.year())"
        MAndDLabel.text = about.ptimes.toString(DateFormat.custom(" MM/dd "))
        contentLabel.text = about.title
        self.contentLabel.textColor = about.isread == 1 ? UIColor.a_color4 : UIColor.a_color3
        
        self.titleHeadightConstraint.constant = hiddenY ? 0 : 21
        
        if let im = about.img,let url = URL(string: im) {
            
            if im.characters.count <= 0 {
                
                cntentRightSpaceConstraint.constant = 17
                descImageView.isHidden = true
            }else{
                
                cntentRightSpaceConstraint.constant = 17+81+15
                descImageView.isHidden = false
                descImageView.pin_setImage(from: url, placeholderImage: UIImage.SharePlaceholderImage())
            }
        }
        
        self.layoutIfNeeded()
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 30, y: rect.height, width: rect.width - 17-17-7-6.5, height: 1));
        
        context?.move(to: CGPoint(x: 20, y: self.isHeader ? (hiddenYear ? 20+6 : 20)  : 0))       //移到線段的第一個點
        context?.addLine(to: CGPoint(x: 20, y: rect.height))       //畫出一條線
        context?.setLineDash(phase: 2, lengths: [1,1])
//        CGContextSetLineDash(context, 0, [1,1], 2)    //設定虛線
        context?.setLineWidth(1)               //設定線段粗細
        UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).set()                        //設定線段顏色
        context?.strokePath()                    //畫出線段
    }
}


class LeftBorderView:UIView{

    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 0, y: 10, width: 1, height: 47));                //畫出線段
    }
}
