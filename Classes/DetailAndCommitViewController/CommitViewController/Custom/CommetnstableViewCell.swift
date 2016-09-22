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
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画机制
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(rect)
        
        // 绘制下边框
        context?.setStrokeColor(UIColor(red: 228/255, green:228/255, blue: 228/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 18, y: rect.height, width: rect.width - 36, height: 1))
        
        // 绘制蓝色标题边框
        let size = CGSize(width: 600, height: 600)
        let titleWidth = NSString(string:titleLabel.text!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 15)], context: nil).width
        context?.setStrokeColor(UIColor(red: 0/255, green:145/255, blue: 250/255, alpha: 1).cgColor)
        context?.stroke(CGRect(x: 18, y: rect.height, width: titleWidth, height: 1))
    }
}
