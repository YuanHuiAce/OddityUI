//
//  BorderView.swift
//  Journalism
//
//  Created by Mister on 16/5/31.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit

class DetailBorderView:UIView{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 4
    }
}


class ShareBottomBorderView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let layout = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 18, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width-18, y: self.frame.size.height))
        
        path.lineWidth = 0.5
        UIColor.a_color5.setStroke()
        path.stroke()
        
        layout.path = path.cgPath
    }
}
