//
//  CommitViewController.swift
//  Journalism
//
//  Created by 荆文征 on 16/5/22.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import RealmSwift
import XLPagerTabStrip

public class CommitViewController: UIViewController,IndicatorInfoProvider {
    
    var new:New?
    
    var currentPage = 1
    
    var hotResults:Results<Comment>!
    var normalResults:Results<Comment>!
    
    @IBOutlet var newInfoLabel: UILabel!
    @IBOutlet var newTitleLabel: UILabel!

    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var tableViewHeaderView: UIView!
    
    public func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        
        let info = IndicatorInfo(title: "评论")
        
        return info
    }

}
