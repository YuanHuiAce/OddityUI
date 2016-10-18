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
    
    static let shareNoInterest:NoInterestView = { return NoInterestView(frame: CGRect.zero)}()

    lazy var label = UILabel()
    lazy var imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 8
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        self.imageView.image = UIImage.OddityImageByName("About")
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self.snp.centerY).offset(-30)
            make.leftMargin.equalTo(20)
        }
        
        label.text = "将减少此类推荐"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.textAlignment = .center
        
        self.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self.snp.centerY)
            make.leftMargin.equalTo(self.imageView.snp.right).offset(15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
