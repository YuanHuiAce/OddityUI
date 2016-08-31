//
//  CommetnstableViewCell.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class CommentsTableViewHeader: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    override func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画机制
        CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextFillRect(context, rect)
        
        // 绘制下边框
        CGContextSetStrokeColorWithColor(context, UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(18, rect.height, rect.width - 36, 1))
        
        // 绘制蓝色标题边框
        let size = CGSize(width: 600, height: 600)
        let titleWidth = NSString(string:titleLabel.text!).boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(15)], context: nil).width
        CGContextSetStrokeColorWithColor(context, UIColor(red: 0/255, green:145/255, blue: 250/255, alpha: 1).CGColor)
        CGContextStrokeRect(context, CGRectMake(18, rect.height, titleWidth, 1))
    }
}
