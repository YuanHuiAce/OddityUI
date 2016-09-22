//
//  CustomView.swift
//  OddityUI
//
//  Created by Mister on 16/8/29.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

///按钮扩展类
class BottomBoderView:UIView{
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let context = UIGraphicsGetCurrentContext() // 获取绘画板
        context?.setFillColor(UIColor.clear.cgColor)
        context?.fill(rect)
        //下分割线
        context?.setStrokeColor(UIColor.a_color10.cgColor)
        context?.stroke(CGRect(x: 0, y: rect.height, width: rect.width, height: 1));
    }
}
