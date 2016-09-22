//
//  DetailViewControllerDataSource.swift
//  Journalism
//
//  Detail VC 关于表格的数据源处理的相关扩展
//
//  Created by Mister on 16/6/12.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import UIKit
import SafariServices

extension DetailViewController:UITableViewDelegate,UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0 } // 隐藏所有的尾部视图
    public func numberOfSections(in tableView: UITableView) -> Int { return 2 } // 无论如何都需要现实三个section。只是有没有内容，再根据具体情况决定
    
    // 生成头视图
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        if (hotResults == nil || hotResults.count == 0 ) && section == 0 {return 0} // 如果是第二个section，是热门评论，所以需要热门评论的头视图
        
        if (aboutResults == nil || aboutResults.count == 0 ) && section == 1 {return 0} // 如果是第三个section 因为是相关观点，判断相关观点的数目之后，决定是否显示相关观点
        
        return 40
    }
    
    // 确定每一个section的数目
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        if section == 0 && (hotResults != nil && hotResults.count > 0 ){ return hotResults.count > 3 ? 4 : hotResults.count } // 如果是第一个，人们评论相关的section
        
        if section == 1 && (aboutResults != nil && aboutResults.count > 0 ){ return aboutResults.count } // 相关新闻的section
        
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if (indexPath as NSIndexPath).section == 0 { // 如果是第三section 则会热门评论的cell
            
            if (indexPath as NSIndexPath).row == 3 { return self.getMoreTableViewCell(indexPath) }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "comments") as! CommentsTableViewCell
            
            let comment = hotResults[(indexPath as NSIndexPath).row]
            
            cell.setCommentMethod(comment, tableView: tableView, indexPath: indexPath)
            
            return cell
        }
        
        let about = self.aboutResults[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "aboutcell") as! AboutTableViewCell
        
        cell.backgroundColor = UIColor.red
        
        cell.isHeader = (indexPath as NSIndexPath).row == 0
        
        cell.setAboutMethod(about,hiddenY: self.getIsHeaderYear(indexPath))
        
        cell.contentLabel.attributedText = about.htmlTitle.toAttributedString()
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        if indexPath.section == 0 {
            if indexPath.row == 3 { return 101 } // 如果是第三行，则固定高度 更多评论
            return hotResults[indexPath.row].HeightByNewConstraint(tableView) // 根据评论内容返回高度
        }
        
        if indexPath.section == 1 {
            return aboutResults[indexPath.row].HeightByNewConstraint(tableView,hiddenY: self.getIsHeaderYear(indexPath)) // 根据相关内容返回高度
        }
        return 99
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    
        if (self.hotResults == nil || self.hotResults.count == 0 ) && section == 0 {return nil}
        
        if (self.aboutResults == nil || self.aboutResults.count == 0 ) && section == 1 {return nil}
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "newcomments") as! CommentsTableViewHeader
        
        if section == 0 { // 如果是第一个 则是 最热评论相关视图
        
            let text = hotResults.count > 0 ? "(\(hotResults.count))" : ""
            
            cell.titleLabel.text = "最热评论\(text)"
        }else{ // 如果是其他，也就是直邮第二个section 说明就是 相关新闻 视图
            
            cell.titleLabel.text = "相关观点"
        }
        
        let containerView = UIView(frame:cell.bounds)
        
        cell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        containerView.addSubview(cell)
        
        return containerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section != 1 { return }
        
        let about = self.aboutResults[(indexPath as NSIndexPath).row]
        
        if about.isread == 0 {
            
            about.isRead() // 标记为已读
        }
        
        if let url = URL(string: about.url) {
        
            if #available(iOS 9.0, *) {
                let viewController = SFSafariViewController(url: url)
                self.present(viewController, animated: true, completion: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
            
            
        }
        
//        self.tableView.reloadData()
    }
}


extension DetailViewController{

    
    // 获取查看全部评论的视图
    fileprivate func getMoreTableViewCell(_ indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "morecell")! as UITableViewCell
        
        /****************	点击按钮活着点击整个cell 发送前往评论视图的消息	****************/
        
        if let button = cell.viewWithTag(10) as? UIButton {
            button.removeActions(events: UIControlEvents.touchUpInside)
            button.addAction(events: .touchUpInside, closure: { (_) in
                NotificationCenter.default.post(name: Notification.Name(rawValue: CLICKTOCOMMENTVIEWCONTROLLER), object: nil)
            })
        }
        cell.addGestureRecognizer(UITapGestureRecognizer(block: { (_) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: CLICKTOCOMMENTVIEWCONTROLLER), object: nil)
        }))
        
        return cell
    }
    
    // 获取头视图是不是隐藏文件
    fileprivate func getIsHeaderYear(_ indexPath:IndexPath) -> Bool{
        if (indexPath as NSIndexPath).row == 0 { return true }
        let before = self.aboutResults[(indexPath as NSIndexPath).row-1]
        let current = self.aboutResults[(indexPath as NSIndexPath).row]
        return before.ptimes.year() == current.ptimes.year()
    }
}
