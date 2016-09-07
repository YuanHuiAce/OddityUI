//
//  NewContent.swift
//  Journalism
//
//  Created by Mister on 16/5/30.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
public class Content: Object {

    /// 用于获取评论的 docid
    dynamic public var txt: String? = nil

    /// 新闻Url
    dynamic public var img: String? = nil

    /// 新闻标题
    dynamic public var vid: String? = nil

}



///  频道的数据模型
public class NewContent: Object {
    /// 新闻ID
    dynamic public var nid = 1
    /// 用于获取评论的 docid
    dynamic public var docid = ""
    /// 新闻Url
    dynamic public var url = ""
    /// 新闻标题
    dynamic public var title = ""
    
    
    /// 新闻事件
    dynamic public var ptime = ""
    dynamic public var ptimes = NSDate()
    
    /// 新闻来源
    dynamic public var pname = ""
    
    /// 来源地址
    dynamic public var purl = ""
    
    /// 频道ID
    dynamic public var channel = 0
    /// 正文图片数量
    dynamic public var inum = 0
    
    /// 新闻标题
    dynamic public var descr = ""

    
    /// 列表图格式，0、1、2、3
    dynamic public var style = 0
    
    /// 图片具体数据
    let tagsList = List<StringObject>() // Should be declared with `let`
    public let content = List<Content>() // Should be declared with `let`
    
    /// 收藏数
    dynamic public var collect = 0
    /// 关心数
    dynamic public var concern = 0
    /// 评论数
    dynamic public var comment = 0
    
    /// 滑动的位置
    dynamic public var scroffY: Double = 0
    
    override public static func primaryKey() -> String? {
        return "nid"
    }
    
}

