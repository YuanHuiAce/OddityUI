//
//  Comment.swift
//  Journalism
//
//  Created by Mister on 16/6/1.
//  Copyright © 2016年 aimobier. All rights reserved.
//

import RealmSwift

///  频道的数据模型
open class Comment: Object {
    
    open dynamic var id = 1 // 新闻评论ID
    open dynamic var nid = 1 // 新闻ID
    open dynamic var uid = 1 // 创建该评论的用户ID
    open dynamic var commend = 0 //点赞数
    open dynamic var upflag = 0 // 用户是否能对该条评论点赞，0、1 对应 可点、不可点
    
    open dynamic var content = "" // 评论正文
    open dynamic var ctime = "" //创建时间
    open dynamic var uname = "" //创建该评论的用户名
    open dynamic var avatar = "" // 新闻标题
    open dynamic var docid = "" // 该评论对应的新闻 docid
    
    open dynamic var ishot = 0
    
    open dynamic var ctimes = Date() //创建时间
    open dynamic var inserttimes = Date() //创建时间
    
    override open static func primaryKey() -> String? {
        return "id"
    }
}
