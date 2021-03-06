//
//  CommitViewControllerExtension.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import MJRefresh
import RealmSwift

extension CommitViewController{

    // 设置数据源对象
    func setResults(){
        
        if let new = new {
            
            let realm = try! Realm()
            
            hotResults = realm.objects(Comment.self).filter("nid = \(new.nid) AND ishot = 1").sorted(byProperty: "commend", ascending: false)
            normalResults = realm.objects(Comment.self).filter("nid = \(new.nid) AND ishot = 0").sorted(byProperty: "ctimes", ascending: false)
        }
        
        self.tableView.reloadData()
    }
    
    // 设置表头视图
    func setHeaderView(){
        
        if let n  = new {
            
            self.newTitleLabel.text = n.title
            self.newTitleLabel.font = UIFont.a_font9
            self.newInfoLabel.font = UIFont.a_font8
            let comment = n.comment > 0 ? "   \(n.comment)评" : ""
            self.newInfoLabel.text = "\(n.pname)  \(n.ptime)\(comment)"
            
            tableViewHeaderView.setNeedsLayout()
            tableViewHeaderView.layoutIfNeeded()
            
            let tsize = CGSize(width: self.view.frame.width-18-18, height: 1000) // 获得标题最宽的宽度
            let titleHeight = NSString(string:self.newTitleLabel.text!).boundingRect(with: tsize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.newTitleLabel.font], context: nil).height // 获得标题所需高度
            let infoHeight = NSString(string:self.newInfoLabel.text!).boundingRect(with: tsize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName:self.newInfoLabel.font], context: nil).height // 获得info所需高度
            
            tableViewHeaderView.frame.size.height = titleHeight+infoHeight+17+33+8
            
            tableView.tableHeaderView = self.tableViewHeaderView
        }
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { (_) in
            
            self.setHeaderView()
            
            }, completion: nil )
    }
}
