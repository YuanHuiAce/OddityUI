//
//  CommentDataSource.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit


extension CommitViewController{

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        guard let hot = hotResults,let normal = normalResults else{ return 0 }
        
        if section == 0 && hot.count <= 0 {
        
            return 0
        }
        
        if section == 1 && normal.count <= 0 {
            
            return 40
        }
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    // 返回有几个 Section
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        return 2
    }
    
    // 设置每一个Section 的 返回个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if hotResults.count <= 0 && normalResults.count <= 0 {
            
            return section == 0 ? 0 : 1
        }
        
        guard let hot = hotResults,let noraml = normalResults else{ return 0}
        
        if section == 0 {
        
            return hot.count
        }
        
        if section == 1 && noraml.count > 0 {
        
            return noraml.count
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        if hotResults.count <= 0 && normalResults.count <= 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "nocell")! as UITableViewCell
            
            return cell
        }
        
        var comment:Comment!
        
        if hotResults.count > 0 && (indexPath as NSIndexPath).section == 0{
            
            comment = hotResults[(indexPath as NSIndexPath).item]
        }else if normalResults.count > 0 && (indexPath as NSIndexPath).section == 1{
            
            comment = normalResults[(indexPath as NSIndexPath).item]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "comments") as! CommentsTableViewCell
        
        cell.setCommentMethod(comment, tableView: tableView, indexPath: indexPath)
        
        cell.setNeedsDisplay()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let _ = hotResults,let _ = normalResults else{ return nil }
        
        if hotResults.count <= 0 && normalResults.count <= 0 && section == 0 { return nil }
        if hotResults.count > 0 && normalResults.count <= 0 && section == 1 {return nil }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newcomments") as! CommentsTableViewHeader
        
        if section == 0 {
            
            let text = hotResults.count > 0 ? "(\(hotResults.count))" : ""
            
            cell.titleLabel.text = "最热评论\(text)"
            
        }else{
        
            let text = (new?.comment ?? 0) > 0 ? "(\((new?.comment ?? 0)-hotResults.count))" : ""
            
            cell.titleLabel.text = "最新评论\(text)"
        }
        
        let containerView = UIView(frame:cell.frame)
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        containerView.addSubview(cell)
        return containerView
    }
}
