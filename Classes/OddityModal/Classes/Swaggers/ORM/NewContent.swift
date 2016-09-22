//
//  NewContent.swift
//  Journalism
//
//  Created by Mister on 16/5/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
open class Content: Object {

    /// 用于获取评论的 docid
    dynamic open var txt: String? = nil

    /// 新闻Url
    dynamic open var img: String? = nil

    /// 新闻标题
    dynamic open var vid: String? = nil

}



///  频道的数据模型
open class NewContent: Object {
    /// 新闻ID
    dynamic open var nid = 1
    /// 用于获取评论的 docid
    dynamic open var docid = ""
    /// 新闻Url
    dynamic open var url = ""
    /// 新闻标题
    dynamic open var title = ""
    
    
    /// 新闻事件
    dynamic open var ptime = ""
    dynamic open var ptimes = Date()
    
    /// 新闻来源
    dynamic open var pname = ""
    
    /// 来源地址
    dynamic open var purl = ""
    
    /// 频道ID
    dynamic open var channel = 0
    /// 正文图片数量
    dynamic open var inum = 0
    
    /// 新闻标题
    dynamic open var descr = ""

    
    /// 列表图格式，0、1、2、3
    dynamic open var style = 0
    
    /// 图片具体数据
    let tagsList = List<StringObject>() // Should be declared with `let`
    open let content = List<Content>() // Should be declared with `let`
    
    /// 收藏数
    dynamic open var collect = 0
    /// 关心数
    dynamic open var concern = 0
    /// 评论数
    dynamic open var comment = 0
    
    /// 滑动的位置
    dynamic open var scroffY: Double = 0
    
    override open static func primaryKey() -> String? {
        return "nid"
    }
    
}

