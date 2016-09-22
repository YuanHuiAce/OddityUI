//
//  HeaderView.swift
//  Journalism
//
//  Created by Mister on 16/6/13.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

class NewRefreshHeaderView: MJRefreshHeader {
    
    var label:UILabel!
    var loading:UIActivityIndicatorView!
    
    override func prepare() {
        
        super.prepare()
        
        self.mj_h = 44
        
        let loading = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        self.addSubview(loading)
        self.loading = loading
        
        let label = UILabel()
        label.textColor = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        self.addSubview(label)
        self.label = label
        
    }
    
    override func placeSubviews() {
        
        super.placeSubviews()
        
        
        self.loading.snp_makeConstraints { (make) in
            
            make.top.equalTo(2)
            make.centerX.equalTo(self)
        }
        
        self.label.snp_makeConstraints { (make) in
            
            make.top.equalTo(self.loading.snp_bottom).offset(10)
            make.centerX.equalTo(self)
        }
    }
    
//    override var pullingPercent:CGFloat{
//    
//        didSet{
//        
//            print(pullingPercent)
//        }
//    }
    
    override var state: MJRefreshState{
    
        didSet{
        
            switch state {
            case .idle:
                self.label.text = "准备推荐"
                self.loading.stopAnimating()
            case .pulling:
                self.label.text = "松开立即刷新"
                self.loading.startAnimating()
            case .refreshing:
                self.label.text = "正在推荐"
                self.loading.startAnimating()
            default:
                break
            }
        }
    }
}
